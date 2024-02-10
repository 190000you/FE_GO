// 계정 찾기 페이지 - 휴대폰 번호
import 'package:flutter/material.dart';

// import : google 폰트
import 'package:google_fonts/google_fonts.dart';

class FindIdEmailPage extends StatefulWidget {
  @override
  FindIdEmailPageState createState() => FindIdEmailPageState();
}

// 계정 찾기 페이지 코드
class FindIdEmailPageState extends State<FindIdEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // 3. 이메일 입력칸
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: '이메일',
              border: OutlineInputBorder(),
            ),
          ),
          // 4. 인증하기 버튼
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 60, // 로그인 버튼 높이 조정
            child: ElevatedButton(
              onPressed: () {
                // !! 이메일 인증하기 버튼 누르면, 본 이메일로 메일 보내야함
                // !! 주의
              },
              child: Text(
                '이메일 인증하기',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
