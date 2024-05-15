// 마이 페이지
import 'package:flutter/material.dart';

// 이후 import로 더 추가할 예정
import 'package:flutter_slidable/flutter_slidable.dart'; // 슬라이더 (delete / share)
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // 아이템 정렬 애니메이션
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장
import 'package:http/http.dart' as http; // API 사용
import 'dart:convert'; // API 호출 : 디코딩
import 'package:intl/intl.dart'; // yyyy.mm.dd형식을 yy.mm.dd형식으로

// 아직 사용 X
String? userAccessToken = "";
String? userRefreshToken = "";

// 플랜 불러오기 1
class PlanDetailsPage extends StatefulWidget {
  final List<dynamic> schedule; // 스케줄 데이터 리스트를 받는다

  PlanDetailsPage({Key? key, required this.schedule}) : super(key: key);

  @override
  _PlanDetailsPageState createState() => _PlanDetailsPageState();
}

// 플랜 불러오기 2
class _PlanDetailsPageState extends State<PlanDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 계획'),
      ),
      body: Column(
        children: <Widget>[
          // 지도를 표시할 임시 컨테이너
          Container(
            height: 200, // 지도의 높이 설정
            color: Colors.grey[300], // 임시 컨테이너의 배경색
            child: Center(
              child: Text('여기에 지도가 표시됩니다'), // 지도 위치 표시 임시 텍스트
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
                itemCount: widget.schedule.length,
                itemBuilder: (context, index) {
                  DateTime startDate =
                      DateTime.parse(widget.schedule[index]['start_date']);
                  String formattedDate =
                      DateFormat('yyyy-MM-dd, HH:mm').format(startDate);

                  return Card(
                    key: ValueKey(
                        widget.schedule[index]['id']), // 각 요소의 고유 key를 설정합니다.
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text('${index + 1}',
                            style: TextStyle(color: Colors.white)),
                      ),
                      title: Text(widget.schedule[index]['place'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("$formattedDate"),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.drag_handle), // 사용자 지정 드래그 핸들 아이콘
                      ),
                    ),
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1; // 새 인덱스 보정
                    }
                    final item = widget.schedule.removeAt(oldIndex);
                    widget.schedule.insert(newIndex, item);
                  });
                },
                buildDefaultDragHandles: false // 기본 드래그 핸들 비활성화
                ),
          ),
        ],
      ),
    );
  }
}

// 마이 페이지 1
class MyPage extends StatefulWidget {
  String userName; // 이전 페이지에서 userName 받아와서 업로드
  MyPage(this.userName);

  @override
  MyPageState createState() => MyPageState();
}

// 마이 페이지 2
class MyPageState extends State<MyPage> {
  bool isFavoriteSelected = false;
  bool isPlanSelected = false;
  bool isReviewSelected = false;
  List<Map<String, dynamic>> userPlans = []; // 플랜 정보
  String userId = ""; // 사용자 ID 데이터
  String userName = ""; // 사용자 이름 정보
  final storage = FlutterSecureStorage(); // Local 내부 저장소 사용

  @override
  void initState() {
    super.initState();

    userName = widget.userName;
    print("userName : " + userName);
    _loadUserId();
  }

  // API 1. User 모델 데이터 가져오기 API
  void _loadUserId() async {
    String? storedUserId = await storage.read(key: 'login_id');
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      fetchLikeForUser();
      fetchPlansForUser().then((plans) {
        setState(() {
          userPlans = plans;
        });
      }).catchError((error) {
        print(error);
      });
    }
  }

  // API 2. 찜목록 리스트 정보 가져오는 API
  Future<void> fetchLikeForUser() async {
    print("fetchLike");
    /*
    final response =
        await http.get(Uri.parse('http://43.203.61.149/user/like/'));
    print(response.statusCode);

    // 200 : 호출 성공 시
    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data = jsonDecode(response.body);
      print(data);
    } else {
      throw Exception('Failed to load plans');
    }
    */
  }

  // API 3. 플랜 정보 가져오기 API
  Future<List<Map<String, dynamic>>> fetchPlansForUser() async {
    final response =
        await http.get(Uri.parse('http://43.203.61.149/plan/plan/'));

    print("fetch");
    // 호출 성공 시
    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseData is Map<String, dynamic>) {
        List<dynamic> plans = responseData['results'];
        List<Map<String, dynamic>> tempUserPlans = [];
        for (var plan in plans) {
          if (plan['user'].toString() == userId) {
            tempUserPlans.add(plan);
          }
        }
        return tempUserPlans;
      } else {
        throw Exception('The expected structure of the response is not found.');
      }
    } else {
      throw Exception('Failed to load plans');
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      isFavoriteSelected = index == 1;
      isPlanSelected = index == 2;
      isReviewSelected = index == 3;
    });
  }

  // 버튼
  ButtonStyle _buttonStyle(bool isSelected) {
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blue : null,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  // 버튼
  Widget _buttonChild(String text, bool isSelected) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  // backgroundImage: AssetImage("assets/profile_image.png"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 2. 사용자 이름 설정
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              readOnly: true,
              initialValue: userName ?? "사용자 이름", // 전역 변수 사용
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _toggleSelection(1),
                  style: _buttonStyle(isFavoriteSelected),
                  child: _buttonChild("찜목록", isFavoriteSelected),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _toggleSelection(2),
                  style: _buttonStyle(isPlanSelected),
                  child: _buttonChild("플랜", isPlanSelected),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _toggleSelection(3),
                  style: _buttonStyle(isReviewSelected),
                  child: _buttonChild("리뷰", isReviewSelected),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: _buildSelectedInfo(),
          ),
        ],
      ),
    );
  }

  // 데이터 정보 불러오기
  Widget _buildSelectedInfo() {
    if (isFavoriteSelected) {
      return _buildFavoriteList();
    } else if (isPlanSelected) {
      return _buildPlanList();
    } else if (isReviewSelected) {
      return Text("리뷰 데이터"); // 이 부분은 원하시는 데이터로 채우세요.
    } else {
      return SizedBox();
    }
  }

  // 리스트 1 : 찜목록
  Widget _buildFavoriteList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: userPlans.length,
            itemBuilder: (context, index) {
              // 일정 시작일을 표시하기 위한 로직
              String formattedDate = "미정"; // 기본값 설정
              if (userPlans[index]['schedule'].isNotEmpty) {
                DateTime startDate = DateTime.parse(
                    userPlans[index]['schedule'][0]['start_date']);
                formattedDate = DateFormat('yy.MM.dd').format(startDate);
              }

              return Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading:
                      Icon(Icons.map, color: Theme.of(context).primaryColor),
                  title: Text(userPlans[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("여행 시작일 : $formattedDate"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanDetailsPage(
                            schedule: userPlans[index]['schedule']),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: _showAddPlanDialog, // 이후에 UI 수정
            child: Text('새 플랜 작성'),
          ),
        ),
      ],
    );
  }

  // 리스트 2 : 플랜
  Widget _buildPlanList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: userPlans.length,
            itemBuilder: (context, index) {
              // 일정 시작일을 표시하기 위한 로직
              String formattedDate = "미정"; // 기본값 설정
              if (userPlans[index]['schedule'].isNotEmpty) {
                DateTime startDate = DateTime.parse(
                    userPlans[index]['schedule'][0]['start_date']);
                formattedDate = DateFormat('yy.MM.dd').format(startDate);
              }

              return Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading:
                      Icon(Icons.map, color: Theme.of(context).primaryColor),
                  title: Text(userPlans[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("여행 시작일 : $formattedDate"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanDetailsPage(
                            schedule: userPlans[index]['schedule']),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: _showAddPlanDialog, // 이후에 UI 수정
            child: Text('새 플랜 작성'),
          ),
        ),
      ],
    );
  }

// 다이얼로그 표시 및 새 플랜 이름 입력 처리
  void _showAddPlanDialog() {
    TextEditingController _planNameController = TextEditingController();

    // 이후에 UI 수정
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("새 플랜 이름 입력"),
          content: TextField(
            controller: _planNameController,
            decoration: InputDecoration(hintText: "플랜 이름을 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('저장'),
              onPressed: () {
                _createPlan(_planNameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// API 호출하여 서버에 새 플랜 데이터 전송
  void _createPlan(String planName) async {
    final response = await http.post(
      Uri.parse('http://43.203.61.149/plan/plan/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": planName,
        "user": userId,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 데이터가 생성되면 UI 업데이트 또는 알림
      print('Plan created successfully.');
    } else {
      // 실패 처리
      print('Failed to create plan. Error: ${response.body}');
    }
  }
}
