// 계정 찾기 페이지
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// 계정 찾기 페이지
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find Id Page',
      home: _FindIdPage(),
    );
  }
}

// 회원가입 페이지
class _FindIdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox.shrink(),
      ),
    );
  }
}
