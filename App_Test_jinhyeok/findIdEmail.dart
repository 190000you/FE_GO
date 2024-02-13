// 계정 찾기 페이지 - 이메일
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class FindIdEmailPage extends StatefulWidget {
  @override
  FindIdEmailPageState createState() => FindIdEmailPageState();
}

class FindIdEmailPageState extends State<FindIdEmailPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();

  bool _isEmailSent = false;
  bool _isCodeVerified = false;

  String _emailVerificationCode = "aaaaaa";

  void _sendEmailVerificationCode() {
    setState(() {
      _isEmailSent = true;
    });
  }

  void _verifyCode(String enteredCode, String correctCode) {
    if (enteredCode == correctCode) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("인증 성공"),
            content: Text("해당 이메일로 계정 정보를 보냈습니다."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
      setState(() {
        _isCodeVerified = true;
      });
    } else {
      showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("인증 실패")),
      content: Text("인증 코드가 올바르지 않습니다."),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("확인"),
          ),
        ),
      ],
    );
  },
);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("계정 찾기"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "이메일 주소",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendEmailVerificationCode,
              child: Text("이메일에 인증코드 보내기"),
            ),
            if (_isEmailSent)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  TextField(
                    controller: _verificationCodeController,
                    decoration: InputDecoration(
                      labelText: "인증 코드",
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _verifyCode(
                          _verificationCodeController.text, _emailVerificationCode);
                    },
                    child: Text("인증하기"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
