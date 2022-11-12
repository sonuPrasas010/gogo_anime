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
import 'package:unity_mediation/unity_mediation.dart';

import 'consts.dart';
import 'functionality.dart';
import 'model/prefs.dart';
import 'services/DataFetcher.dart';
import 'video.dart';

class ChooseServer extends StatefulWidget {
  final String url, imageUrl;
  const ChooseServer(this.url, this.imageUrl, {Key? key}) : super(key: key);

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

  void increaseRequestTime() => rewardRequestedTime++;

  @override
  void initState() {
    _streamController = StreamController();
    fetchVideo();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Server"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: _isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(
                      // strokeWidth: 1,
                      radius: 12,
                      color: Colors.white,
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: ((context, index) {
                      // if (index == 3) {
                      //   return FacebookNativeAd(
                      //     placementId: "600792398257188_600792468257181",
                      //     adType: NativeAdType.NATIVE_AD,
                      //     width: double.infinity,
                      //     height: 300,
                      //     backgroundColor: Colors.blue,
                      //     titleColor: Colors.white,
                      //     descriptionColor: Colors.white,
                      //     buttonColor: Colors.deepPurple,
                      //     buttonTitleColor: Colors.white,
                      //     buttonBorderColor: Colors.white,
                      //     listener: (result, value) {
                      //       print("Native Ad: $result --> $value");
                      //     },
                      //     keepExpandedWhileLoading: false,
                      //     expandAnimationDuraion: 1000,
                      //   );
                      // }
                      return const Divider();
                    }),
                    itemCount: servers.length,
                    itemBuilder: (_, index) => MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () async {
                        var packageInfo = await PackageInfo.fromPlatform();
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
                      child: Text(
                        servers[index]['name'] ?? "",
                        style: const TextStyle(
                          color: TEXT_COLOR,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
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
