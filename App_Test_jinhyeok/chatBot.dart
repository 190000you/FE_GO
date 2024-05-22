import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(ChatBotApp());

class ChatBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  String? planId;
  List<Map<String, dynamic>> schedule = [];
  List<Map<String, dynamic>> savedPlaces = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? messagesJson = prefs.getString('chat_messages');
    if (messagesJson != null) {
      setState(() {
        messages
            .addAll(List<Map<String, dynamic>>.from(jsonDecode(messagesJson)));
      });
    }
  }

  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('chat_messages', jsonEncode(messages));
  }

  Future<void> sendMessage(String message) async {
    String? token = await storage.read(key: 'login_access_token');
    String? storedUserId = await storage.read(key: 'login_id');

    if (token == null) {
      setState(() {
        messages.add({'type': 'bot', 'text': '토큰을 가져오지 못했습니다'});
      });
      await _saveMessages();
      return;
    }

    setState(() {
      messages.add({'type': 'user', 'text': message});
      messages.add({'type': 'loading'});
    });
    await _saveMessages();
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

            for (var placeName in botResponse) {
              await _fetchPlaceDetails(placeName);
            }
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

          for (var placeName in botResponse) {
            await _fetchPlaceDetails(placeName);
          }
        }
      } catch (e) {
        setState(() {
          messages.removeWhere((msg) => msg['type'] == 'loading');
          messages.add({'type': 'bot', 'text': '응답을 파싱하는 데 실패했습니다: $e'});
        });
      }
    } else {
      setState(() {
        messages.removeWhere((msg) => msg['type'] == 'loading');
        messages.add({'type': 'bot', 'text': '응답을 가져오지 못했습니다'});
      });
    }
    await _saveMessages();
    _scrollToBottom();
  }

  Future<void> _fetchPlaceDetails(String placeName) async {
    print('추천: ' + placeName);
    final body = jsonEncode({'name': placeName});

    final response = await http.post(
      Uri.parse('http://43.203.61.149/place/find/'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      try {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final placesByName = responseData['places_by_name'] as List<dynamic>;

        if (placesByName.isNotEmpty) {
          final placeDetails = placesByName.first as Map<String, dynamic>;
          final placeId = placeDetails['id'].toString();
          print('추천: ' + placeId);

          setState(() {
            savedPlaces.add({
              'name': placeName,
              'id': placeId,
            });
          });
        }
      } catch (e) {
        setState(() {
          messages.add({'type': 'bot', 'text': '장소 세부 정보를 파싱하는 데 실패했습니다: $e'});
        });
      }
    } else {
      setState(() {
        messages.add({'type': 'bot', 'text': '장소 세부 정보를 가져오지 못했습니다'});
      });
    }
    await _saveMessages();
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

  void _handleCreatePlan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlanCreationDialog(
          onSave: (planName) => _createPlan(planName),
        );
      },
    );
  }

  Future<void> _createPlan(String planName) async {
    String? storedUserId = await storage.read(key: 'login_id');

    if (storedUserId == null) {
      setState(() {
        messages.add({'type': 'bot', 'text': '사용자 ID를 가져오지 못했습니다'});
      });
      await _saveMessages();
      return;
    }

    final response = await http.post(
      Uri.parse('http://43.203.61.149/plan/plan/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": planName,
        "user": storedUserId,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      planId = responseData['id'].toString();
      print('플랜이 생성되었습니다. ID: $planId');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TravelPlanPage(
            planId: planId!,
            places: savedPlaces,
            onSaveComplete: _handleSaveComplete,
          ),
        ),
      );
    } else {
      setState(() {
        messages.add({'type': 'bot', 'text': '플랜을 생성하지 못했습니다'});
      });
    }
    await _saveMessages();
    _scrollToBottom();
  }

  void _handleSaveComplete() {
    setState(() {
      messages.add({'type': 'bot', 'text': '플랜을 저장했어요!'});
    });
    _saveMessages();
    _scrollToBottom();
  }

  void _clearMessages() async {
    setState(() {
      messages.clear();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearMessages,
          ),
        ],
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
                } else if (message['type'] == 'place') {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(right: 5, left: 10, top: 5),
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
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID: ${message['id']}',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  Text(
                                    message['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(right: 5, left: 10, top: 5),
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
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
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
                                        .toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (message['response'] != null &&
                            message['response'].isNotEmpty)
                          Center(
                            child: ElevatedButton(
                              onPressed: _handleCreatePlan,
                              child: Text('플랜 작성하기'),
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

class PlanCreationDialog extends StatelessWidget {
  final TextEditingController planController = TextEditingController();
  final Function(String) onSave;

  PlanCreationDialog({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('플랜 작성하기'),
      content: TextField(
        controller: planController,
        decoration: InputDecoration(labelText: '플랜을 입력해주세요'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSave(planController.text);
            Navigator.of(context).pop();
          },
          child: Text('저장하기'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
      ],
    );
  }
}

class TravelPlanPage extends StatefulWidget {
  final String planId;
  final List<Map<String, dynamic>> places;
  final Function onSaveComplete;

  TravelPlanPage(
      {required this.planId,
      required this.places,
      required this.onSaveComplete});

  @override
  _TravelPlanPageState createState() => _TravelPlanPageState();
}

class _TravelPlanPageState extends State<TravelPlanPage> {
  late List<Map<String, dynamic>> _places;

  @override
  void initState() {
    super.initState();
    _places = List<Map<String, dynamic>>.from(widget.places);
  }

  Future<void> addToPlan(String planId, String placeId) async {
    DateTime now = DateTime.now().toUtc(); // 현재 UTC 시간
    String formattedDate = now.toIso8601String(); // 현재 시간을 ISO 8601 포맷으로 변환

    final response = await http.post(
      Uri.parse('http://43.203.61.149/plan/schedule/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'start_date': formattedDate, // 현재 시간을 시작 날짜로 설정
        'end_date': formattedDate, // 현재 시간을 종료 날짜로 설정
        'place': placeId,
        'plan': planId,
      }),
    );

    if (response.statusCode == 201) {
      print("장소 추가 성공");
    } else {
      print("장소 추가 실패: ${response.body}");
    }
  }

  void _savePlan() async {
    for (var place in _places) {
      await addToPlan(widget.planId, place['id']);
    }
    widget.onSaveComplete();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('플랜이 성공적으로 저장되었습니다.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 계획'),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                '임시 컨테이너',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1; // 새 인덱스 보정
                  }
                  final item = _places.removeAt(oldIndex);
                  _places.insert(newIndex, item);
                });
              },
              buildDefaultDragHandles: false, // 사용자 지정 드래그 핸들 사용
              children: [
                for (int index = 0; index < _places.length; index++)
                  ListTile(
                    key: ValueKey(_places[index]['id']),
                    title: Text(
                      _places[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: Icon(Icons.drag_handle),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _savePlan,
              child: Text('저장 하기'),
            ),
          ),
        ],
      ),
    );
  }
}
