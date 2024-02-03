// 회원가입 페이지
import 'package:flutter/material.dart';

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
      title: 'Sign Up',
      home: SignUpPage(),
    );
  }
}

// 회원가입 페이지
class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar : Appbar
      appBar: AppBar(
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.of(context).pop(); // 현재 페이지를 스택에서 제거하여 이전 페이지로 이동
          },
        ),
        title: SizedBox.shrink(),
      ),
      // body : Padding
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 회원가입 위 글자 삽입
            SizedBox(height: 20),
            Text(
              // 글자 및 폰트, 크기 수정
              'Let\'s go?',
              style: GoogleFonts.oleoScript(fontSize: 36),
            ),
            // 2. 이름 입력칸
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
            ),
            // 3. ID 입력칸
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),
            ),
            // 4. PW 입력칸
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            // 5. 닉네임 입력칸
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: '사용자 닉네임',
                border: OutlineInputBorder(),
              ),
            ),
            // 6. 회원가입 버튼
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  '회원가입',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
