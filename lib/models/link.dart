class Link {
  final String description;
  final String title;
  final String img;
  final String url;

  Link({this.description, this.title, this.url, this.img});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      description: json['description'],
      title: json['title'],
      img: json['img'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'title': title,
        'img': img,
        'url': url,
      };
}
