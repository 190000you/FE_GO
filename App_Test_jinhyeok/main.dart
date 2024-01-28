import 'package:flutter/material.dart';

// Import 'flutter_spinkit' plugin
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

// Import : 로그인 페이지
import 'package:go_test_ver/login.dart';

// Import : 목종이 작업물들

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: MainPage(), // MainPage를 홈으로 설정합니다.
      home: LoadingPage(), // 로딩 페이지를 홈으로 설정
    );
  }
}

// 1. 로딩 페이지 (메인 페이지)
class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

// 로딩 페이지 상태
class _LoadingPageState extends State<LoadingPage> {
  // 1-1. 3초 뒤 로그인 페이지로 이동
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  // 1-2. 로딩 애니메이션
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Create SpinKitPumpingHeart()
              SpinKitWave(
                // 1. 색상
                color: Colors.red,
                // 2. 크기
                size: 50.0,
                // 3. 애니메이션 시간
                duration: Duration(seconds: 2),
              ),
            ],
          )),
    );
  }
}
