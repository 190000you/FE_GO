// 메인 페이지
import 'package:flutter/material.dart';

// import : 로딩 애니메이션 패키지
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

// import : 로그인 페이지로 이어짐
import 'package:go_test_ver/login.dart';
// import : google 폰트
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

// 로딩 페이지를 앱 시작점으로 설정.
// 로딩 시간 동안 데이터 불러오기
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
    // 시간 설정
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
