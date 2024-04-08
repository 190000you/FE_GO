// 메인 페이지
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart'; // Google Fonts 패키지를 가져옵니다.
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장

// import package 파일
import 'package:go_test_ver/homeScreen.dart';
import 'package:go_test_ver/postCard.dart';
import 'package:go_test_ver/searchPage.dart';
import 'package:go_test_ver/chatBot.dart';
import 'package:go_test_ver/survey.dart';
import 'package:go_test_ver/myPage.dart';

// 메인 페이지
// 이후에 mainpage.dart 파일 만들어서 옮기기.
class MainPage extends StatefulWidget {
  final String access; // access 데이터를 저장하는 변수 추가
  final String refresh; // refresh 데이터를 저장하는 변수 추가

  MainPage(this.access, this.refresh); // 생성자 업데이트

  @override
  _MainPageState createState() => _MainPageState();
}

// 메인페이지 코드
class _MainPageState extends State<MainPage> {
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  static final storage = FlutterSecureStorage();
  late String access;
  late String refresh;

  int _selectedIndex = 0;

  // 하단 네비게이션 바
  List<BottomNavigationBarItem> bottomItems = [
    // 1. 메인 페이지 : 라벨, 아이콘
    BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.home),
    ),
    // 2. 검색 페이지 : 라벨, 아이콘
    BottomNavigationBarItem(
      label: '검색',
      icon: Icon(Icons.search),
    ),
    // 3. 챗봇 페이지 : 라벨, 페이지
    // 교체 -> 설무조사 페이지 완성
    BottomNavigationBarItem(
      label: '챗봇',
      icon: Icon(Icons.question_answer),
    ),

    // 4. 마이 페이지 : 라벨, 페이지
    BottomNavigationBarItem(
      label: '내 정보',
      icon: Icon(Icons.person),
    ),
  ];

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    access = widget.access; // 이전 페이지에서 Access Token 받아서 저장
    refresh = widget.refresh; // 이전 페이지에서 Refresh Token 받아서 저장
    // print("access 2 : " + widget.access);
    // print("refresh 2 : " + widget.refresh);

    pages = [
      HomeScreen(access, refresh), // 저장한 Token 전달
      SearchPage(access, refresh), // 저장한 Token 전달
      // if문 + storage 사용해서, API 연결 - user 데이터에 is_survey : 0 OR 1 보고
      SurveyScreen(access, refresh),
      // ChatBotPage(widget.access, widget.refresh), // 저장한 Token 전달
      MyPage(widget.access, widget.refresh), // 저장한 Token 전달
    ];
  }

  // Token 읽어오는법
  //  String userInfo = await storage.read(key: "login");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0, // 제목과 아이콘 사이의 공간을 제거합니다.
        title: Padding(
            // 제목에 패딩을 추가합니다.
            padding:
                EdgeInsets.only(top: 5.0, right: 45.0), // 위쪽과 왼쪽에 패딩을 추가합니다.
            child: Center(
              // 제목 글자 : 가볼까?
              child: Text(
                'Let\'s go?',
                style: GoogleFonts.oleoScript(fontSize: 36),
                // 글꼴을 'Oleo Script regular font'로 설정하고, 글자 크기를 36으로 설정합니다.
              ),
            )),
      ),
      // 하단 네비게이션 바 UI
      // 색상 및 크기
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 10,
        currentIndex: _selectedIndex,

        showSelectedLabels: false, //아이콘 밑 글씨 삭제
        showUnselectedLabels: false,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: bottomItems,
      ),
      // 하단에서 선택된 페이지 보여줌
      body: pages[_selectedIndex], // 선택된 인덱스에 해당하는 페이지를 보여줍니다.
    );
  }
}
