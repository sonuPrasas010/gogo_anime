import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/TvModel.dart';

class DataFetcher {
  Future<List<Anime>> fetchData(String url) async {
    List<Anime> _animes = [];
    var response = await http.get(
      Uri.parse(
        url,
      ),
    );

    var document = jsonDecode(response.body);
    for (var item in document) {
      _animes.add(Anime.fromJson(item));
    }

    return _animes;
  }

  Future<Map> fetchVideo(String url) async {
    debugPrint("Fetch video url: $url");
    var response = await http.get(
      Uri.parse(
        url,
      ),
    );
    var document = jsonDecode(response.body);
    debugPrint(document.toString());
    return document;
  }
}
