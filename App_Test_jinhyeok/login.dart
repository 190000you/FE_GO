// 로그인 페이지
import 'package:flutter/material.dart';

// import : 순서대로 메인페이지/회원가입/아이디 찾기/비밀번호 찾기 페이지로 이어짐
import 'package:go_test_ver/mainPage.dart'; // mainPage.dart 파일 import
import 'package:go_test_ver/signUp.dart'; // signUp.dart 파일 import
import 'package:go_test_ver/findId.dart'; // findId.dart 파일 import
import 'package:go_test_ver/findPw.dart'; // findPw.dart 파일 import

// import : google 폰트
import 'package:google_fonts/google_fonts.dart';

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

// 로그인 페이지
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar : 제목 삭제함
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox.shrink(),
      ),
      // body
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(height: 100),
          // 1. 로그인 위 글자 삽입함 : Let's go?
          Text(
            'Let\'s go?', // 폰트는 나중에 통일하기
            style: GoogleFonts.oleoScript(fontSize: 36),
          ),
          // 2. ID 입력칸 : 관리자 == admin
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: '아이디',
              border: OutlineInputBorder(),
            ),
          ),
          // 3. PW 입력칸 : 관리자 == 1234
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: '비밀번호',
              border: OutlineInputBorder(),
            ),
          ),
          // 4. 로그인 버튼
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
          // 5. 회원가입 버튼
          SizedBox(height: 10), // 간격 조정
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // 회원가입 버튼 : 왼쪽과 오른쪽으로 정렬
            children: [
              SizedBox(
                // 회원가입 버튼 크기 조정
                width: 140, // 버튼 너비 조정
                height: 40, // 버튼 높이 조정
                child: ElevatedButton(
                  onPressed: () {
                    // 회원가입 버튼 눌렀을 때의 동작 추가
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, // 버튼 배경색 투명하게 설정
                    elevation: 0, // 그림자 없애기
                  ),
                  child: Text(
                    '회원가입',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              // 6. 계정 찾기 버튼
              SizedBox(
                // 계정 찾기 버튼 크기 조정
                width: 140, // 버튼 너비 조정
                height: 40, // 버튼 높이 조정
                child: ElevatedButton(
                  onPressed: () {
                    // 계정 찾기 버튼 눌렀을 때의 동작 추가
                    // 계정 찾기 페이지 생성 후 페이지 이동

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindIdPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, // 버튼 배경색 투명하게 설정
                    elevation: 0, // 그림자 없애기
                  ),
                  child: Text(
                    '계정 찾기',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              SizedBox(
                // 7. 비밀번호 찾기 버튼
                width: 140, // 버튼 너비 조정
                height: 40, // 버튼 높이 조정
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindPwPage()),
                    );
                    // 비밀번호 찾기 버튼 눌렀을 때의 동작 추가
                    // 비밀번호 찾기 페이지 생성 후 페이지 이동
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, // 버튼 배경색 투명하게 설정
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
        ]),
      ),
    );
  }

  // 아이디와 비밀번호가 일치하는지 확인하는 함수
  bool _checkLogin(String id, String password) {
    return id == "admin" && password == "1234";
  }
}
