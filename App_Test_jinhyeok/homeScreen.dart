import 'package:flutter/material.dart';
import 'package:go_test_ver/postCard.dart';

class HomeScreen extends StatefulWidget {
  final String access;
  final String refresh;

  HomeScreen(this.access, this.refresh);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    print("homeScreen access : " + widget.access);
    print("homeScreen refresh : " + widget.refresh);
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
