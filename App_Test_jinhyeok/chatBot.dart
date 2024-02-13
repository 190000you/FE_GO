import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  @override
  ChatBotPageState createState() => ChatBotPageState();
}

class ChatBotPageState extends State<ChatBotPage> {
  TextEditingController _textController = TextEditingController();
  // !! 처음 인사도 역시 챗봇이 인사하는 것처럼 채팅 박스 만들기 !!
  List<Map<String, dynamic>> messages = [{"text": "챗봇입니다.", "isBot": true}];

  // !! 채팅 답변 임의로 정해둠
  // !! 나중에 AI 합치면은 다시 되돌아봐야함.
  void _sendMessage(String message) {
    setState(() {
      messages.add({"text": message, "isBot": false});
      if (message == "안녕" || message == "안녕하세요" || message == "ㅎㅇ") {
        messages.add({"text": "안녕하세요! 저는 가볼까? 의 챗봇입니다. 무엇이든지 질문해주세요!", "isBot": true});
      } else if (message == "인기있는 여행지는 어디인가요?") {
        messages.add({"text": "파리, 런던, 도쿄 등이 인기있는 여행지입니다.", "isBot": true});
      } else {
        messages.add({"text": "죄송합니다. 제가 알아들을 수 없는 질문입니다.", "isBot": true});
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
              bool isBot = messages[index]["isBot"] ?? false;
              return Align(
                alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isBot ? Colors.blue[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    messages[index]["text"] ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
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
