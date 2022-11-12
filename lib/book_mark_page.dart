import 'package:flutter/material.dart';


import 'database.dart';
import 'detailsPage.dart';

class BookMarkPage extends StatefulWidget {


  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  List<LocalAnime> localAnimeList = [];
  bool _isLoading = true;

  @override
  void initState() {
    getBookMarks();
    super.initState();
  }

  void getBookMarks() {
    setState(() {
      _isLoading = true;
    });
    MyDatabase.instance.readAllAnime().then(
      (value) {
        localAnimeList = value;
        setState(() {
          _isLoading = false;
        });
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        getBookMarks();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: localAnimeList.isEmpty
            ? const Center(
                child: Text("No Bookmarks"),
              )
            : Center(
                child: GridView.builder(
                    itemCount: localAnimeList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsPage(
                                localAnimeList[index].url,
                                localAnimeList[index].name,
                             
                              ),
                            ),
                          );
                        },
                        child: GridTile(
                          child: Image.network(
                            localAnimeList[index].image,
                            fit: BoxFit.cover,
                          ),
                          footer: Container(
                            color: Colors.white70,
                            child: Column(
                              children: [
                                Text(
                                  localAnimeList[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Released Year: ${localAnimeList[index].epNYear}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
      ),
    );
  }
}
