import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(ChatBotApp());

class ChatBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // DEBUG 배너 제거
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  final ScrollController _scrollController = ScrollController();
  final storage = FlutterSecureStorage();

  Future<void> sendMessage(String message) async {
    // 토큰 불러오기
    String? token = await storage.read(key: 'login_access_token');

    if (token == null) {
      setState(() {
        messages.add({'type': 'bot', 'text': 'Failed to get token'});
      });
      return;
    }

    setState(() {
      messages.add({'type': 'user', 'text': message});
      messages.add({'type': 'loading'});
    });
    _scrollToBottom();

    final response = await http.post(
      Uri.parse('http://43.203.61.149/plan/recommand'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: utf8.encode(jsonEncode({'user_input': message})),
    );

    if (response.statusCode == 200) {
      try {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          messages.removeWhere((msg) => msg['type'] == 'loading');
        });

        if (responseData is List) {
          for (var item in responseData) {
            final chatResponse = item['chat_response'] as String;
            final botResponse = item['response'] != null
                ? List<String>.from(item['response'] as List<dynamic>)
                : [];

            setState(() {
              messages.add({
                'type': 'bot',
                'text': chatResponse,
                'response': botResponse,
              });
            });
          }
        } else if (responseData is Map<String, dynamic>) {
          final chatResponse = responseData['chat_response'] as String;
          final botResponse = responseData['response'] != null
              ? List<String>.from(responseData['response'] as List<dynamic>)
              : [];

          setState(() {
            messages.add({
              'type': 'bot',
              'text': chatResponse,
              'response': botResponse,
            });
          });
        }
      } catch (e) {
        setState(() {
          messages.removeWhere((msg) => msg['type'] == 'loading');
          messages.add({'type': 'bot', 'text': 'Failed to parse response: $e'});
        });
      }
    } else {
      setState(() {
        messages.removeWhere((msg) => msg['type'] == 'loading');
        messages.add({'type': 'bot', 'text': 'Failed to get response'});
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                if (message['type'] == 'user') {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  );
                } else if (message['type'] == 'loading') {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.3,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 6),
                          Text(''),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5, left: 10, top: 5),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              '?',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['text'],
                                style: TextStyle(color: Colors.black87),
                              ),
                              if (message['response'] != null)
                                ...message['response']
                                    .map<Widget>((item) => Text('• $item'))
                                    .toList()
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '대화를 입력해주세요',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
