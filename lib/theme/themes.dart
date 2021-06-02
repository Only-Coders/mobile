import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class CustomTheme extends ChangeNotifier {
  static bool _isDarkTheme = false;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color(0xff00CDAE),
      accentColor: Colors.black.withOpacity(0.9),
      secondaryHeaderColor: Color(0xff34374B),
      errorColor: Color(0xffff5252),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Color(0xff00CDAE),
      primarySwatch: createMaterialColor(Color(0xff00CDAE)),
      accentColor: Colors.white.withOpacity(0.9),
      secondaryHeaderColor: Color(0xff26272D),
      // secondaryHeaderColor: Color(0xff1E1E1E),
      cardColor: Color(0xff1E1E1E),
      dialogBackgroundColor: Color(0xff1E1E1E),
      scaffoldBackgroundColor: Color(0xff121212),
      canvasColor: Color(0xff1E1E1E),
    );
  }
}
