import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/theme/themes.dart';

class GitPlatform extends StatelessWidget {
  final String platform;

  const GitPlatform({Key key, @required this.platform}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return platformItem();
  }

  Widget platformItem() {
    switch (platform) {
      case "GITHUB":
        return currentTheme.currentTheme == ThemeMode.light
            ? SvgPicture.asset(
                "assets/images/github.svg",
                width: 30,
              )
            : Image.asset(
                "assets/images/github-dark.png",
                width: 30,
              );
      case "GITLAB":
        return SvgPicture.asset(
          "assets/images/gitlab.svg",
          width: 30,
        );
      default:
        return SvgPicture.asset(
          "assets/images/bitbucket.svg",
          width: 30,
        );
    }
  }
}
