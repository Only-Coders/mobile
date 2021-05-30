import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigationKey;

  static NavigationService instance = NavigationService();

  NavigationService() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _rn) {
    return navigationKey.currentState.pushReplacementNamed(_rn);
  }

  Future<dynamic> navigateToRemoveUntil(String _rn) {
    return navigationKey.currentState
        .pushNamedAndRemoveUntil(_rn, (Route<dynamic> route) => false);
  }
}
