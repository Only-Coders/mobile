class GitPlatform {
  final String platform;
  final String userName;

  GitPlatform({this.platform, this.userName});

  factory GitPlatform.fromJson(Map<String, dynamic> json) {
    return GitPlatform(
      platform: json['platform'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'userName': userName,
      };
}
