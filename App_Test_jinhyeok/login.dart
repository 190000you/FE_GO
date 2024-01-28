import 'package:flutter/material.dart';
import 'package:go_test_ver/mainpage.dart'; // mainpage.dart 파일 import
import 'package:go_test_ver/signup.dart'; // signup.dart 파일 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Login Page 글자 제거
        automaticallyImplyLeading: false,
        title: SizedBox.shrink(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              'Let\'s go?',
              style: TextStyle(
                fontSize: 36, // 글씨 크기 키움
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60, // 로그인 버튼 높이 조정
              child: ElevatedButton(
                onPressed: () {
                  // 아이디와 비밀번호가 admin, 1234일 때 mainpage로 이동
                  if (_checkLogin("admin", "1234")) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  } else {
                    // 로그인 실패 시 처리
                    print("로그인 실패");
                  }
                },
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 10), // 간격 조정
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽으로 정렬
              children: [
                SizedBox(
                  width: 140, // 버튼 크기 작게 조정
                  height: 40, // 버튼 높이 작게 조정
                  child: ElevatedButton(
                    onPressed: () {
                      // 회원가입 버튼 눌렀을 때의 동작 추가
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // 배경색 투명하게 설정
                      elevation: 0, // 그림자 없애기
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(
                  width: 140, // 버튼 크기 작게 조정
                  height: 40, // 버튼 높이 작게 조정
                  child: ElevatedButton(
                    onPressed: () {
                      // 계정 찾기 버튼 눌렀을 때의 동작 추가
                      print("계정 찾기 버튼 클릭");
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // 배경색 투명하게 설정
                      elevation: 0, // 그림자 없애기
                    ),
                    child: Text(
                      '계정 찾기',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(
                  width: 140, // 버튼 크기 작게 조정
                  height: 40, // 버튼 높이 작게 조정
                  child: ElevatedButton(
                    onPressed: () {
                      // 비밀번호 찾기 버튼 눌렀을 때의 동작 추가
                      print("비밀번호 찾기 버튼 클릭");
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // 배경색 투명하게 설정
                      elevation: 0, // 그림자 없애기
                    ),
                    child: Text(
                      '비밀번호 찾기',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 아이디와 비밀번호가 일치하는지 확인하는 함수
  bool _checkLogin(String id, String password) {
    return id == "admin" && password == "1234";
  }
}
