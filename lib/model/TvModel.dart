class Anime {
  final String title;
  final String image;
  final String epNYear;
  final String link;
  Anime({required this.title,required this.image,required this.epNYear,required this.link});

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      title: json['title'],
      image: json['image'],
      epNYear: json['epNYear'],
      link: json['link'],
    );
  }
}
