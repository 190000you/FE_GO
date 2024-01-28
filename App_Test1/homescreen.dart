import 'package:flutter/material.dart';
import 'package:flutter_application_2/postcard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
