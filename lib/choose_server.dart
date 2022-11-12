import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_gogo_anime/ad_rotation.dart';
import 'package:new_gogo_anime/admob/facebook_ads.dart';
import 'package:new_gogo_anime/admob/unity_ads.dart';
import 'package:new_gogo_anime/categories.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_mediation/unity_mediation.dart';

import 'consts.dart';
import 'functionality.dart';
import 'model/prefs.dart';
import 'services/DataFetcher.dart';
import 'video.dart';

class ChooseServer extends StatefulWidget {
  final String url, imageUrl, currentEpisode, name;
  final int maxEpisode;
  const ChooseServer(this.url, this.imageUrl, this.name,
      {required this.currentEpisode, required this.maxEpisode, Key? key})
      : super(key: key);

  @override
  State<ChooseServer> createState() => _ChooseServerState();
}

class _ChooseServerState extends State<ChooseServer> {
  late StreamController<Map> _streamController;
  List<Map<String, dynamic>> servers = <Map<String, dynamic>>[];
  String _downLoadUrl = '';
  bool _isLoading = true;
  int rewardRequestedTime = 0;
  bool isRewardedAdLoading = false;
  int currentEp = 0;
  late SharedPreferences _sharedPreferences;

  void increaseRequestTime() => rewardRequestedTime++;

  @override
  void initState() {
    currentEp = int.parse(widget.currentEpisode);
    _streamController = StreamController();
    fetchVideo();
    saveToPrefs();
    UnityAds.showAd();
    super.initState();
    _streamController.stream.listen((data) {
      setState(() {
        _isLoading = false;
        servers.add(
          {
            'name': "vidstream",
            'url': data['vidstream'],
          },
        );
        servers.add(
          {
            'name': "gogo",
            'url': data['gogo'],
          },
        );
        servers.add(
          {
            'name': "stram sb",
            'url': data['streamsb'],
          },
        );
        servers.add(
          {
            'name': "Xstream",
            'url': data['xstreamcdn'] ?? "",
          },
        );
        servers.add(
          {
            'name': "mp4upload",
            'url': data['mp4upload'],
          },
        );
        servers.add(
          {
            'name': "dood stream",
            'url': data['doodStream'],
          },
        );
        servers.add(
          {
            'name': "Download",
            'url': data['downloadLink'],
          },
        );

        _downLoadUrl = data['downloadLink'];
      });
    }).onError((err) {
      debugPrint(err.toString());
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void saveToPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool(widget.url, true);
    log("saved to prefs");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Server"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.85),
          child: _isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(
                    // strokeWidth: 1,
                    radius: 12,
                    color: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${widget.name} (Episode ${widget.currentEpisode})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        if (currentEp != 1)
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: _sharedPreferences
                                              .getBool(widget.url.replaceAll(
                                            "-episode-$currentEp",
                                            "-episode-${currentEp - 1}",
                                          )) ==
                                          true
                                      ? Colors.green
                                      : Theme.of(context).primaryColor),
                              onPressed: () {
                                var url = widget.url.replaceAll(
                                    "-episode-$currentEp",
                                    "-episode-${currentEp - 1}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChooseServer(
                                        url,
                                        widget.imageUrl,
                                        widget.name,
                                        currentEpisode:
                                            (currentEp - 1).toString(),
                                        maxEpisode: widget.maxEpisode,
                                      ),
                                    ));
                              },
                              icon: const Icon(
                                Icons.keyboard_double_arrow_left,
                              ),
                              label: const Text("prev"),
                            ),
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (currentEp != widget.maxEpisode)
                          Expanded(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: _sharedPreferences
                                              .getBool(widget.url.replaceAll(
                                            "-episode-$currentEp",
                                            "-episode-${currentEp + 1}",
                                          )) ==
                                          true
                                      ? Colors.green
                                      : Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  var url = widget.url.replaceAll(
                                      "-episode-$currentEp",
                                      "-episode-${currentEp + 1}");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChooseServer(
                                        url,
                                        widget.imageUrl,
                                        widget.name,
                                        currentEpisode:
                                            (currentEp + 1).toString(),
                                        maxEpisode: widget.maxEpisode,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.keyboard_double_arrow_right,
                                ),
                                label: const Text("Next"),
                              ),
                            ),
                          ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    for (var index = 0; index < servers.length; index++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 15,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          child: MaterialButton(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            highlightColor: Colors.green,
                            splashColor: Colors.white,
                            hoverColor: Colors.green,
                            focusColor: Colors.green,
                            color: Colors.black,
                            onPressed: () async {
                              var packageInfo =
                                  await PackageInfo.fromPlatform();
                              if (servers[index]['name'] == "Download") {
                                Functionality.launchUniversalLinkIos(
                                    defaultUrl: servers[index]['url'] +
                                        "&package=${packageInfo.packageName}&version=${packageInfo.version}");
                                return;
                              }
                              if (mounted) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayer(
                                      servers[index]['url'] ??
                                          "https://tormovie.online/404",
                                    ),
                                  ),
                                );
                              }
                              debugPrint(servers[index]['url']);
                            },
                            child: Row(
                              children: [
                                if (servers[index]['name'] != "Download")
                                  const Icon(
                                    Icons.play_circle_outline_rounded,
                                    color: Colors.white,
                                  )
                                else
                                  const Icon(
                                    Icons.downloading,
                                    color: Colors.white,
                                  ),
                                const Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  servers[index]['name'] ?? "",
                                  style: const TextStyle(
                                    color: TEXT_COLOR,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(
                                  flex: 3,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    servers[index]['name'] != "Download"
                                        ? "Watch"
                                        : "Download",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> fetchVideo() async {
    debugPrint("${widget.url}&package_name=$packageName&version=$buildNumber");

    setState(() {
      _isLoading = true;
    });
    try {
      if (!_streamController.isClosed) {
        _streamController.add(await DataFetcher().fetchVideo(
            "${widget.url}&package_name=$packageName&version=$buildNumber"));
      }
    } catch (e) {
      if (!_streamController.isClosed) _streamController.addError(e);
    }
  }
}
