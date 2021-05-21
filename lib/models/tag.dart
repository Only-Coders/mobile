class Tag {
  final String canonicalName;
  final int followerQuantity;

  Tag({this.canonicalName, this.followerQuantity});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      canonicalName: json['canonicalName'],
      followerQuantity: json['followerQuantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'canonicalName': canonicalName,
        'followerQuantity': followerQuantity,
      };
}
