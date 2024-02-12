import 'package:flutter/material.dart';
import 'package:go_test_ver/homeScreen.dart';
import 'package:go_test_ver/postcard.dart';
import 'package:google_fonts/google_fonts.dart'; // Google Fonts 패키지를 가져옵니다.

// 메인 페이지
// 이후에 mainpage.dart 파일 만들어서 옮기기.
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

// 메인페이지 코드
class _MainPageState extends State<MainPage> {
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

  List pages = [
    // 1. 메인 페이지
    HomeScreen(),
    // 2. 검색 페이지
    SearchPage(),
    // 3. 챗봇 페이지
    ChatBotPage(),
    // 4. 마이 페이지
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
            padding:
                EdgeInsets.only(top: 5.0, left: 35.0), // 위쪽과 왼쪽에 패딩을 추가합니다.
            child: Center(
              // 제목 글자 : 가볼까?
              child: Text(
                'Let\'s go?',
                style: GoogleFonts.oleoScript(fontSize: 36),
                // 글꼴을 'Oleo Script regular font'로 설정하고, 글자 크기를 36으로 설정합니다.
              ),
            )),
        actions: [
          // AppBar의 오른쪽 끝에 아이콘을 추가합니다.
          Padding(
            // 아이콘에 패딩을 추가합니다.
            padding: EdgeInsets.only(top: 6.5), // 위쪽에 패딩을 추가합니다.
            child: Icon(Icons.search,
                size: 40), // 돋보기 아이콘을 추가하고, 아이콘 크기를 40으로 설정합니다.
          ),
          SizedBox(width: 40), // 아이콘과 AppBar의 오른쪽 끝 사이에 공간을 추가합니다.
        ],
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

// 챗봇 페이지
class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

// 챗봇 페이지 상태
class _ChatBotPageState extends State<ChatBotPage> {
  TextEditingController _textController = TextEditingController();
  // !! 처음 인사도 역시 챗봇이 인사하는 것처럼 채팅 박스 만들기 !!
  List<String> messages = ["챗봇입니다."];

  // !! 채팅 답변 임의로 정해둠
  // !! 나중에 AI 합치면은 다시 되돌아봐야함.
  void _sendMessage(String message) {
    setState(() {
      messages.add(message);
      if (message == "안녕" || message == "안녕하세요" || message == "ㅎㅇ") {
        messages.add("안녕하세요! 저는 가볼까? 의 챗봇입니다. 무엇이든지 질문해주세요!");
      } else if (message == "인기있는 여행지는 어디인가요?") {
        messages.add("파리, 런던, 도쿄 등이 인기있는 여행지입니다.");
      } else {
        messages.add("죄송합니다. 제가 알아들을 수 없는 질문입니다.");
      }
      _textController.clear();
    });
  }

  // 챗봇 페이지 UI
  @override
  Widget build(BuildContext context) {
    return Column(
      // children 으로 묶음 (1)
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(messages[index]),
                dense: true,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "메시지 입력",
                  ),
                  onSubmitted: (String message) {
                    _sendMessage(message);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    _sendMessage(_textController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
