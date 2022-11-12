import 'dart:async';

import 'package:flutter/material.dart';

import 'detailsPage.dart';
import 'functionality.dart';
import 'model/TvModel.dart';
import 'services/DataFetcher.dart';

class ListPage extends StatefulWidget {
  final String url;
  final String title;
  ListPage({
    required this.url,
    required this.title,
  });
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with AutomaticKeepAliveClientMixin {
  List<Anime> _animes = [];
  int pageNum = 1;
  bool isLoading = false;
  late ScrollController _scrollController;
  final DataFetcher _dataFetcher = DataFetcher();
  late StreamController<List<Anime>> _streamController;

  @override
  void initState() {
    _streamController = StreamController();
    _scrollController = ScrollController();
    fetchItems();
    super.initState();

    _streamController.stream.listen((event) {
      setState(() {
        _animes.addAll(event);

        pageNum++;
        isLoading = false;
      });
    }).onError((err) {
      setState(() {
        isLoading = false;
      });
    });
    _scrollController.addListener(() {
      if (Functionality.checkPosition(_scrollController.position.pixels,
              _scrollController.position.maxScrollExtent) &&
          !isLoading) {
        fetchItems();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading && _animes.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              )
            : _animes.isEmpty
                ? Center(
                    child: ElevatedButton(
                      onPressed: () {
                        fetchItems();
                        // getData(
                        //   "${widget.url}?page=$pageNum",
                        // );
                      },
                      child: const Text(
                        "Reload",
                      ),
                    ),
                  )
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailsPage(
                                      _animes[index].link,
                                      _animes[index].title,
                                      // widget.isAdLoaded,
                                      // widget.bannerAd,
                                    ),
                                  ),
                                );
                              },
                              child: GridTile(
                                child: Image.network(
                                  _animes[index].image,
                                  fit: BoxFit.cover,
                                ),
                                footer: Container(
                                  color: Colors.white70,
                                  child: Column(
                                    children: [
                                      Text(
                                        _animes[index].title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        _animes[index].epNYear,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: _animes.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: isLoading
                            ? const SizedBox(
                                height: 80,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : null,
                      ),
                    ],
                  )

        /*GridView.builder(
                  controller: _scrollController,
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _animes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: GridTile(
                        child: Image.network(
                          _animes[index].image,
                          fit: BoxFit.cover,
                        ),
                        footer: Container(
                          color: Colors.white70,
                          child: Column(
                            children: [
                              Text(
                                _animes[index].title ?? "tt",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _animes[index].epNYear ?? "ep",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),*/
        );
  }

  Future<void> fetchItems() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (!_streamController.isClosed) {
        _streamController
            .add(await _dataFetcher.fetchData("${widget.url}&page=$pageNum"));
      }
    } catch (e) {
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
