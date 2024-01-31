// 비밀번호 찾기 페이지
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// 비밀번호 찾기 페이지
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find PW Page',
      home: _FindPwPage(),
    );
  }
}

// 회원가입 페이지
class _FindPwPage extends StatelessWidget {
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
