import 'package:flutter/material.dart';
import 'package:go_test_ver/homescreen.dart';
import 'package:go_test_ver/postcard.dart';
import 'package:google_fonts/google_fonts.dart'; // Google Fonts 패키지를 가져옵니다.

// 메인 페이지
// 이후에 mainpage.dart 파일 만들어서 옮기기.
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      label: '검색',
      icon: Icon(Icons.search),
    ),
    BottomNavigationBarItem(
      label: '챗봇',
      icon: Icon(Icons.question_answer),
    ),
    BottomNavigationBarItem(
      label: '내 정보',
      icon: Icon(Icons.person),
    ),
  ];

  List pages = [
    HomeScreen(),
    Container(
      child: Center(child: Text("2번")),
    ),
    Container(
      child: Center(child: Text("3번")),
    ),
    Container(
      child: Center(child: Text("4번")),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0, // 제목과 아이콘 사이의 공간을 제거합니다.
        title: Padding(
          // 제목에 패딩을 추가합니다.
          padding: EdgeInsets.only(top: 14.0, left: 65.0), // 위쪽과 왼쪽에 패딩을 추가합니다.
          child: Center(
            // 제목을 중앙에 위치시킵니다.
            child: Text(
              'Lets Go',
              style: GoogleFonts.oleoScript(
                  fontSize:
                      36), // 글꼴을 'Oleo Script regular font'로 설정하고, 글자 크기를 36으로 설정합니다.
            ),
          ),
        ),
        actions: [
          // AppBar의 오른쪽 끝에 아이콘을 추가합니다.
          Padding(
            // 아이콘에 패딩을 추가합니다.
            padding: EdgeInsets.only(top: 14.0), // 위쪽에 패딩을 추가합니다.
            child: Icon(Icons.search,
                size: 40), // 돋보기 아이콘을 추가하고, 아이콘 크기를 40으로 설정합니다.
          ),
          SizedBox(width: 40), // 아이콘과 AppBar의 오른쪽 끝 사이에 공간을 추가합니다.
        ],
      ),
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
      body: pages[_selectedIndex], // 선택된 인덱스에 해당하는 페이지를 보여줍니다.
    );
  }
}

// 각 페이지를 위한 위젯을 정의합니다.