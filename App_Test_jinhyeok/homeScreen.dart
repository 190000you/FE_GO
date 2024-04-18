import 'package:flutter/material.dart';
import 'package:go_test_ver/postCard.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final storage = FlutterSecureStorage();
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return PostCard(
            number: index,
          );
        },
      ),
    );
  }
}
