import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_gogo_anime/admob/unity_ads.dart';
import 'package:new_gogo_anime/database.dart';

 import 'choose_server.dart';
import 'consts.dart';
import 'services/DataFetcher.dart';

class DetailsPage extends StatefulWidget {
  final String link;
  final String title;
  DetailsPage(
    this.link,
    this.title,
  );
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isLoading = false;
  // List<Map<String, String>> _episodes = [];
  Map _info = {};
  late StreamController _controller;
  DataFetcher _dataFetcher = DataFetcher();
  List<bool> _selection = [];
  final List<Map<String, int>> _episodesList = [];
  List _toShowEpisodes = [];
  bool _isBookMarked = false;
  bool isBookMarking = false;
  String bookMarkMsg = "";

  @override
  void initState() {
    MyDatabase.instance.readAnime(widget.link).then((value) {
      if (value != null) {
        setState(() {
          _isBookMarked = true;
          bookMarkMsg = "Remove from Bookmarks";
        });
        return;
      }
      bookMarkMsg = "Add to Bookmarks";
    }).onError((error, stackTrace) {
      bookMarkMsg = "Add to Bookmarks";
    });

    _controller = StreamController();
    // showInterstitialAd();
    // UnityAds.showAd();
    // showAdmobInterstitialAd();
    // showMaxAd();
    _loadData();
    super.initState();
    _controller.stream.listen((event) {
      _info = event;
      // generating pisodes groups
      int maxEp = _info['episodesList'].length;
      _episodesList.add({
        "epStart": 1,
        "epEnd": maxEp,
      });
      for (; maxEp >= 0; maxEp -= 100) {
        if (maxEp < 100) {
          _episodesList.add(
            {
              'epStart': maxEp - (maxEp - 1),
              'epEnd': maxEp,
            },
          );
        } else {
          _episodesList.add({
            'epStart': maxEp - 100,
            'epEnd': maxEp,
          });
        }
      }

      // end generating episodes groups
      setState(() {
        _selection = List.generate(
          _episodesList.length,
          (index) => false,
        );
        isLoading = false;
        // }
      });
    }).onError((err) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // persistentFooterButtons: [
          //      widget.bannerAd != null && widget.isAdLoaded
          //       ? SizedBox(
          //           height: widget.bannerAd?.size.height.toDouble(),
          //           width: widget.bannerAd?.size.width.toDouble(),
          //           child: AdWidget(ad: widget.bannerAd!))
          //       : Container(),
          // ],
          body: isLoading
              ?const LinearProgressIndicator()
              : _info.isEmpty
                  ? Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _loadData();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reload"),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(_info['image']),
                            fit: BoxFit.cover),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.8),
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          slivers: [
                            SliverAppBar(
                              backgroundColor: Theme.of(context).primaryColor,
                              pinned: true,
                              expandedHeight: 400,
                              automaticallyImplyLeading: true,

                              // backgroundColor: Colors.blue,

                              flexibleSpace: FlexibleSpaceBar(
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 56.0),
                                  child: Text("${widget.title}"),
                                ),
                                centerTitle: true,

                                // titlePadding: EdgeInsets.only(left: 10),
                                background: Image.network(
                                  _info["image"] ?? "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        runAlignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            "$bookMarkMsg:",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          if (!_isBookMarked)
                                            IconButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                setState(() {
                                                  _isBookMarked =
                                                      !_isBookMarked;
                                                  bookMarkMsg =
                                                      "Remove from Bookmarks";
                                                });

                                                MyDatabase.instance.create(
                                                  LocalAnime(
                                                    name: _info['title'],
                                                    image: _info['image'],
                                                    url: widget.link,
                                                    type: "season",
                                                    epNYear:
                                                        _info['releasedYear'],
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.bookmark_add,
                                              ),
                                            )
                                          else
                                            IconButton(
                                              color: Colors.greenAccent,
                                              onPressed: () {
                                                setState(() {
                                                  _isBookMarked =
                                                      !_isBookMarked;
                                                  bookMarkMsg =
                                                      "Add to Bookmarks";
                                                });

                                                MyDatabase.instance
                                                    .delete(widget.link);
                                              },
                                              icon: const Icon(
                                                Icons.bookmark_remove,
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "Year: ${_info['releasedYear']}",
                                        style: const TextStyle(
                                            fontSize: 20, color: TEXT_COLOR),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        'Type: ${_info['type']}',
                                        style: const TextStyle(
                                            fontSize: 20, color: TEXT_COLOR),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        'Genre: ${_info['genre']}',
                                        style: const TextStyle(
                                            fontSize: 20, color: TEXT_COLOR),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        'Status: ${_info['status']}',
                                        style: const TextStyle(
                                            fontSize: 20, color: TEXT_COLOR),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "Synopsis: ${_info['synopsis']}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: TEXT_COLOR,
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "Other Name: ${_info['otherName']}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: TEXT_COLOR,
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ToggleButtons(
                                        // direction: Axis.vertical,
                                        selectedColor: Colors.green,
                                        fillColor: Colors.green,
                                        highlightColor: Colors.green,
                                        onPressed: (selected) {
                                          setState(() {
                                            for (int i = 0;
                                                i < _selection.length;
                                                i++) {
                                              _selection[i] = i == selected;
                                            }
                                            int start = _episodesList[selected]
                                                    ['epStart'] ??
                                                1;
                                            int end = _episodesList[selected]
                                                    ['epEnd'] ??
                                                1;
                                            _toShowEpisodes =
                                                _info['episodesList']
                                                    .sublist(start - 1, end);
                                          });
                                        },
                                        isSelected: _selection,
                                        children: _episodesList.map((e) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3.0),
                                            child: Chip(
                                              label: (e['epEnd']! -
                                                          e['epStart']! ==
                                                      _info["episodesList"]
                                                              .length -
                                                          1)
                                                  ? const Text("All Episodes")
                                                  : Text(
                                                      "Episode ${e['epStart']} - ${e['epEnd']}"),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 50,
                                mainAxisExtent: 50,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: _toShowEpisodes[index]
                                                  ['isSelected'] !=
                                              null
                                          ? Colors.green
                                          : Theme.of(context).primaryColor,
                                      padding: const EdgeInsets.all(0)),
                                  onPressed: () {
                                   
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChooseServer(
                                          _toShowEpisodes[index]['link'],
                                          _info['image'],
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      _toShowEpisodes[index]['isSelected'] =
                                          true;
                                    });
                                  },
                                  child: Text(
                                      "Episode ${_toShowEpisodes[index]["name"]}"),
                                ),
                                addAutomaticKeepAlives: true,
                                addRepaintBoundaries: false,
                                childCount: _toShowEpisodes.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

          //  GridView.builder(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 4,
          //         childAspectRatio: 6 / 3,
          //         mainAxisSpacing: 20,
          //         crossAxisSpacing: 20),
          //     itemCount: _episodes.length,
          //     itemBuilder: (context, index) {
          //       return GestureDetector(
          //         onTap: () {
          //           Navigator.push(
          //               context, MaterialPageRoute(builder: (_) => VideoPlayer()));
          //         },
          //         child: Container(
          //           color: Colors.blue,
          //           child: Text(_episodes[index]['name']),
          //         ),
          //       );
          //     }),

          ),
    );
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      _controller.add(await _dataFetcher.fetchVideo(widget.link));
    } catch (e) {
      _controller.addError(e);
    }
  }
}
