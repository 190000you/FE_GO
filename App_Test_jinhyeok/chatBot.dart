import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  @override
  ChatBotPageState createState() => ChatBotPageState();
}

class ChatBotPageState extends State<ChatBotPage> {
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [
    {"text": "챗봇입니다.", "isBot": true}
  ];

  void _addMessageAndScroll(String message, bool isBot) {
    setState(() {
      messages.add({"text": message, "isBot": isBot});

      if (messages.length > 20) {
        messages.removeRange(0, messages.length - 20);
      }

      _textController.clear();
    });

    // 스크롤 최하단으로 이동
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      // 사용자가 보낸 메시지를 채팅창에 표시
      _addMessageAndScroll(message, false);

      if (message.toLowerCase() == '추천해줘') {
        // '추천 여행지 확인하기' 버튼을 리스트에 추가
        _addMessageAndScroll("추천 여행지 확인하기", true);
      } else {
        // 일반적인 챗봇 응답 메시지
        _addMessageAndScroll("챗봇 응답 메시지", true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: false,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              bool isBot = messages[index]["isBot"] ?? false;
              String text = messages[index]["text"] ?? "";

              if (isBot && text == "추천 여행지 확인하기") {
                // 챗봇 응답 창에 버튼을 나타내기
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // '추천 여행지 확인하기' 버튼을 눌렀을 때의 동작 추가
                      _addMessageAndScroll("추천 여행지 확인하기 버튼이 눌렸습니다.", true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '추천 여행지 확인하기',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              } else {
                // 일반적인 메시지 표시
                return Align(
                  alignment:
                      isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isBot ? Colors.blue[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }
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
