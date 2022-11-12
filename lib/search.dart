import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detailsPage.dart';
import 'functionality.dart';
import 'model/TvModel.dart';

import 'services/DataFetcher.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _controller;
  final List<Anime> _animes = [];
  bool isLoading = false;
  int page = 1;

  late StreamController _streamController;
  late ScrollController _scrollController;

  @override
  void initState() {
    _streamController = StreamController();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    super.initState();

    _streamController.stream.listen((data) {
      setState(() {
        isLoading = false;
        page++;
        _animes.addAll(data);
      });
    }).onError((err) {
      setState(() {
        debugPrint(err);
        isLoading = false;
      });
    });
    _scrollController.addListener(() {
      if (Functionality.checkPosition(_scrollController.position.pixels,
              _scrollController.position.maxScrollExtent) &&
          !isLoading) {
        searchMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Search"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 9,
                  child: TextField(
                    controller: _controller,
                  )),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(8),
                  color: Colors.blueGrey,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      searchAnime();
                    },
                  ),
                ),
              ),
            ],
          ),
          isLoading && page == 1
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3 / 4,
                        crossAxisSpacing: 10,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _animes.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailsPage(
                                    _animes[index].link,
                                    _animes[index].title,
                                    ),
                              ),
                            );
                          },
                          child: GridTile(
                            footer: Container(
                              color: Colors.white70,
                              child: Column(
                                children: [
                                  Text(
                                    _animes[index].title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _animes[index].epNYear,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            child: Image.network(
                              _animes[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                ),
          if (page > 1 && isLoading) const CupertinoActivityIndicator()
        ],
      ),
    );
  }

  Future<void> searchAnime() async {
    page = 1;
    setState(() {
      isLoading = true;
      _animes.clear();
    });
    try {
      if (!_streamController.isClosed) {
        _streamController.add(await DataFetcher().fetchData(
            "http://toranime.online/apis/anime_search.php?search-term=${_controller.text}&page=$page"));
      }
    } catch (e) {
      debugPrint(e.toString());
      if (!_streamController.isClosed) _streamController.addError(e);
    }
  }

  Future<void> searchMore() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (!_streamController.isClosed) {
        _streamController.add(await DataFetcher().fetchData(
            "http://toranime.online/apis/anime_search.php?search-term=${_controller.text}&page=$page"));
      }
    } catch (e) {
      debugPrint(e.toString());
      if (!_streamController.isClosed) _streamController.addError(e);
    }
  }
}
