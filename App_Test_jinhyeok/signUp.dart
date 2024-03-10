// 회원가입 페이지
import 'package:flutter/material.dart';
import 'package:go_test_ver/login.dart';

// import : 
import 'package:google_fonts/google_fonts.dart'; // google 폰트
import 'package:email_validator/email_validator.dart'; // 이메일 유효성 라이브러리

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

class SignUpPage extends StatefulWidget { // Stateful : 유저 화면에도 정보 반영
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

// 회원가입 페이지
class _SignUpPageState extends State<SignUpPage> { 
  // Form Key
  final formKey = GlobalKey<FormState>(); // formKey 정의
  bool isOk = false;

  // 변수
  String userEmail = "";
  String userName = "";
  String userId = "";
  String userPassword = "";
  String userPasswordCheck = "";


  // 인증
  void tryValidation() {
    final isValid = formKey.currentState!.validate(); // 인증된 상태 여부 확인

    if (isValid) { // 인증 완료
      formKey.currentState!.save();
      isOk = true;
    }
    else{ // 인증 실패
      print("인증 실패");
    }
  }

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
        child: Form(
          key: formKey,
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
            // 2. 이메일 인증
            SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty || value.length < 2) {
                  // 이메일 입력란이 비어있으면 '이메일을 입력해주세요' 리턴
                  return "이메일을 입력해주세요";
                } else if (!EmailValidator.validate(value.toString())) {
                  // 입력값이 이메일 형식에 맞지 않으면 '이메일 형식을 맞춰주세요를 리턴
                  return "이메일 형식을 맞춰주세요";
                } else {
                  return null;
                }
              },
              onSaved: (value) async { // 이메일 저장
                userEmail = value!;
              },
              onChanged: (value) {
                userEmail = value;
              },
              // obscureText: true, // *로 표시 설정/해제
              decoration: InputDecoration(
                labelText: '이메일 입력',
                border: OutlineInputBorder(),
              ),
              key: const ValueKey(1), // 이메일 오류
            ),
            // 3. 이름 입력칸
            SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  // 이름 입력란이 비어 있을 때
                  return "이름을 입력해주세요";
                } else {
                  return null;
                }
              },
              onSaved: (value) { // 이름 저장
                userName = value!;
              },
              onChanged: (value) {
                userName = value;
              },
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
              key: const ValueKey(2), // 이름 오류
            ),
            // 4. ID 입력칸
            SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  // ID 입력란이 비어 있거나, ID가 설정해둔 자릿수 미만이면, '최소 6자리로 ID를 설정해주세요' 리턴
                  return "최소 6자리로 아이디를 설정해주세요";
                } else {
                  return null;
                }
              },
              onSaved: (value) { // Id 저장
                userId = value!;
              },
              onChanged: (value) {
                userId = value;
              },
              decoration: InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),
              key: const ValueKey(3), // ID 오류
            ),
            // 5. PW 입력칸
            SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  // 비밀번호 입력란이 비어 있거나, 비밀번호가 설정해둔 자릿수 미만이면, '최소 6자리로 비밀번호를 설정해주세요' 리턴
                  return "최소 6자리로 비밀번호를 설정해주세요";
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                userPassword = value!;
              },
              onChanged: (value) {
                userPassword = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
              key: const ValueKey(4), // PW 오류
            ),
            // 6. 비밀번호 재입력
            SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty || value.length < 6 || value != userPassword) {
                  return '비밀번호를 다시 확인해주세요.';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                userPasswordCheck = value!;
              },
              onChanged: (value) {
                userPasswordCheck = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 재입력',
                border: OutlineInputBorder(),
              ),
              key: const ValueKey(5), // PW 확인 오류
            ),
            // 6. 회원가입 버튼
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  tryValidation(); // 인증 진행
                  // 인증 완료 시, user 정보 출력
                  print(userEmail);
                  print(userName);
                  print(userId);
                  print(userPassword);
                  print(userPasswordCheck);
                  // 이메일 패스워드 확인
                  if (userEmail != '' && userName != '' && userId != '' && userPassword != '' && userPasswordCheck != ''   && isOk == true) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('회원가입 성공'),
                          content: Text('회원가입에 성공했습니다.'),
                          actions: [
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ).then((value) {
                      // 확인 버튼을 누른 후에 로그인 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    });
                  }
                  // 실패 시, 로그인 창으로 이동하는데, 팝업창 띄우기로? 
                  else {
                  }
                },
                child: Text(
                  '회원가입',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
