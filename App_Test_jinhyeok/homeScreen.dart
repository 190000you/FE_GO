import 'package:flutter/material.dart';
import 'package:go_test_ver/postCard.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장

class HomeScreen extends StatefulWidget {
  final String access;
  final String refresh;

  HomeScreen(this.access, this.refresh);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final storage = FlutterSecureStorage();
  late String access;
  late String refresh;

  void initState() {
    super.initState();
    access = widget.access; // 이전 페이지에서 Access Token 받아서 저장
    refresh = widget.refresh; // 이전 페이지에서 Refresh Token 받아서 저장

    print("homeScreen access : " + access);
    print("homeScreen refresh : " + refresh);
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
