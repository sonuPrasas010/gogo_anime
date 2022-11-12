import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
   String? image, title, episode, link;
  final MaterialPageRoute? route;
  MovieCard({this.image, this.title, this.episode, this.link, this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context, route!);
        },
        child: Stack(alignment: Alignment.bottomCenter, children: [
          SizedBox(
            width: 200,
            height: 300,
            child: Image.network(
              image??"",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 200,
            color: Colors.white70,
            child: Column(
              children: [
                Text(
                  title??"",
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  episode??"",
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
