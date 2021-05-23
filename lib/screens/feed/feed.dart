import 'package:flutter/material.dart';
import 'package:mobile/components/generic/bottom_nav.dart';

class Feed extends StatelessWidget {
  const Feed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
