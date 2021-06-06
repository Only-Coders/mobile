class PostTag {
  final String canonicalName;
  final String displayName;

  PostTag({this.canonicalName, this.displayName});

  factory PostTag.fromJson(Map<String, dynamic> json) {
    return PostTag(
      canonicalName: json['canonicalName'],
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'canonicalName': canonicalName,
        'displayName': displayName,
      };
}
