// 로그인 페이지
import 'dart:io';

import 'package:flutter/material.dart';

// import : 순서대로 메인페이지/회원가입/아이디 찾기/비밀번호 찾기 페이지로 이어짐
import 'package:go_test_ver/mainPage.dart'; // mainPage.dart 파일 import
import 'package:go_test_ver/signUp.dart'; // signUp.dart 파일 import
import 'package:go_test_ver/findId.dart'; // findId.dart 파일 import
import 'package:go_test_ver/findPw.dart'; // findPw.dart 파일 import

// import : google 폰트
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert'; // API 호출 : 디코딩
import 'package:http/http.dart' as http; // API 호출 2

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

// Login API(1): 데이터 저장
class loginAPI {
  String? userId;
  String? userPassword;

  loginAPI({this.userId, this.userPassword});

  loginAPI.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userPassword = json['userPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userPassword'] = this.userPassword;
    return data;
  }
}

// Login API(2) : 함수 호출 및 API URL 연결
Future<void> fetchloginAPI(id, password, context) async {
  // 데이터 저장 변수 : signUpAPI
  final signUpUser = loginAPI(
    userId: id,
    userPassword: password,
  );

  // API 연결
  final response = await http.post(
    Uri.parse('http://43.203.61.149/user/login/'),
    headers: {"Accept": "application/json"},
    body: signUpUser.toJson(),
  );

  // 로그인 처리 과정
  // 200 : 로그인 성공
  // 오류 400 : 데이터 처리 오류

  // 로그인 성공 & 실패
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse =
        jsonDecode(response.body); // JSON 데이터 피싱
    // 응답 메시지 디코드
    // 문제 : 디코드 전 Token 데이터 값을 쿠키에 저장
    String message = jsonResponse['message']; // 응답 메시지 확인
    if (message == "login success") {
      // Toekn을 디코드 후 저장
      String access = jsonResponse['token']['access'];
      String refresh = jsonResponse['token']['refresh'];
      // 문제 : ID 추출
      print(access);
      print(refresh);

      // 문제 : 사용자 ID별 데이터 불러오기

      // 로그인 성공
      final snackBar = SnackBar(content: Text("로그인 성공"));
      // 메인 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainPage(access, refresh)), // 다음 화면으로 이동
      );
    } else {
      final snackBar = SnackBar(content: Text('Token 인증에 실패했습니다.'));
    }
  } else if (response.statusCode == 400) {
    // 로그인 실패 : 아이디, 비밀번호 일치 X
    final snackBar = SnackBar(content: Text('회원 정보가 없습니다.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print('회원 정보가 없습니다.');
  } else {
    // 로그인 실패 : 아이디, 비밀번호 입력 X
    final snackBar = SnackBar(content: Text('아이디와 비밀번호를 정확하게 입력해주세요.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // throw Exception('회원가입 실패: ${response.statusCode}');
  }
}

class LoginPage extends StatefulWidget {
  // StatefulWidget : User 정보 반영하기 위해
  @override
  LoginPageState createState() => LoginPageState();
}

// 로그인 페이지
class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>(); // formKey 정의

  // 변수
  String userId = "";
  String userPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar : 제목 삭제함
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox.shrink(),
      ),
      // body
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  // 1. 로그인 위 글자 삽입함 : Let's go?
                  Text(
                    'Let\'s go?', // 폰트는 나중에 통일하기
                    style: GoogleFonts.oleoScript(fontSize: 36),
                  ),
                  // 2. ID 입력칸 : 관리자 == admin // ID 입력칸
                  SizedBox(height: 20),
                  TextFormField(
                    maxLength: 15, // 글자수 제한
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        // ID 입력란이 비어 있거나, ID가 설정해둔 자릿수 미만이면, '아이디를 입력해주세요' 리턴
                        return "아이디를 입력해주세요";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      // ID 저장(1)
                      userId = value!;
                    },
                    onChanged: (value) {
                      // ID 저장(2)
                      userId = value;
                    },
                    key: const ValueKey(1), // ID 오류
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: '아이디',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  // 3. PW 입력칸 : 관리자 == 1234 // PW 입력칸 안 넣었음
                  SizedBox(height: 20),
                  TextFormField(
                    maxLength: 15, // 글자수 제한
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
                    key: const ValueKey(2),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: '비밀번호',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  // 4. 로그인 버튼
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60, // 로그인 버튼 높이 조정
                    child: ElevatedButton(
                      onPressed: () async {
                        // tryValidation(); // 인증 진행
                        if (userId != '' && userPassword != '') {
                          await fetchloginAPI(
                              userId, userPassword, context); // loginAPI 시도
                        } else {
                          final snackBar =
                              SnackBar(content: Text('아이디와 비밀번호를 입력해주세요.'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 테두리를 둥글게 설정
                        ),
                        elevation: 4, // 그림자 추가
                        backgroundColor: Colors.white, // 배경색을 흰색으로 설정
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  // 5. 회원가입 버튼
                  SizedBox(height: 10), // 간격 조정
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // 회원가입 버튼 : 왼쪽과 오른쪽으로 정렬
                    children: [
                      Flexible(
                        child: SizedBox(
                          // 회원가입 버튼 크기 조정
                          width: 140, // 버튼 너비 조정
                          height: 40, // 버튼 높이 조정
                          child: ElevatedButton(
                            onPressed: () {
                              // 회원가입 버튼 눌렀을 때의 동작 추가
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent, // 버튼 배경색 투명하게 설정
                              elevation: 0, // 그림자 없애기
                            ),
                            child: Text(
                              '회원가입',
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center, // 텍스트 가운데 정렬
                            ),
                          ),
                        ),
                      ),
                      // 6. 계정 찾기 버튼
                      Flexible(
                        child: SizedBox(
                          // 계정 찾기 버튼 크기 조정
                          width: 140, // 버튼 너비 조정
                          height: 40, // 버튼 높이 조정
                          child: ElevatedButton(
                            onPressed: () {
                              // 계정 찾기 버튼 눌렀을 때의 동작 추가
                              // 계정 찾기 페이지 생성 후 페이지 이동

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FindIdPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent, // 버튼 배경색 투명하게 설정
                              elevation: 0, // 그림자 없애기
                            ),
                            child: Text(
                              '계정 찾기',
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center, // 텍스트 가운데 정렬
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          // 7. 비밀번호 찾기 버튼
                          width: 140, // 버튼 너비 조정
                          height: 40, // 버튼 높이 조정
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FindPwPage()),
                              );
                              // 비밀번호 찾기 버튼 눌렀을 때의 동작 추가
                              // 비밀번호 찾기 페이지 생성 후 페이지 이동
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent, // 버튼 배경색 투명하게 설정
                              elevation: 0, // 그림자 없애기
                            ),
                            child: Text(
                              '비밀번호 찾기',
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center, // 텍스트 가운데 정렬
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
