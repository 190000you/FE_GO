// 마이 페이지
import 'package:flutter/material.dart';

// 이후 import로 더 추가할 예정
import 'package:flutter_slidable/flutter_slidable.dart'; // 슬라이더 (delete / share)
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // 아이템 정렬 애니메이션
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장
import 'package:http/http.dart' as http; // API 사용
import 'dart:convert'; // API 호출 : 디코딩
import 'package:intl/intl.dart'; // yyyy.mm.dd형식을 yy.mm.dd형식으로

class MyPage extends StatefulWidget {
  MyPage();

  @override
  MyPageState createState() => MyPageState();
}

class PlanDetailsPage extends StatefulWidget {
  final List<dynamic> schedule; // 스케줄 데이터 리스트를 받는다

  PlanDetailsPage({Key? key, required this.schedule}) : super(key: key);

  @override
  _PlanDetailsPageState createState() => _PlanDetailsPageState();
}

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
            child: ListView.builder(
              itemCount: widget.schedule.length,
              itemBuilder: (context, index) {
                DateTime startDate =
                    DateTime.parse(widget.schedule[index]['start_date']);
                String formattedDate =
                    DateFormat('yyyy-MM-dd, HH:mm').format(startDate);

                return Card(
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
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyPageState extends State<MyPage> {
  bool isFavoriteSelected = false;
  bool isPlanSelected = false;
  bool isReviewSelected = false;
  List<Map<String, dynamic>> userPlans = [];
  String userId = '';
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    // 여기 문제
    String? storedUserId = await storage.read(key: 'login_id');
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      fetchPlansForUser().then((plans) {
        setState(() {
          userPlans = plans;
        });
      }).catchError((error) {
        print(error);
      });
    }
  }

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

  ButtonStyle _buttonStyle(bool isSelected) {
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blue : null,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    );
  }

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
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              initialValue: "사용자 이름",
              textAlign: TextAlign.center,
              onChanged: (value) {},
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

  Widget _buildSelectedInfo() {
    if (isFavoriteSelected) {
      return Text("찜목록 데이터"); // 이 부분은 원하시는 데이터로 채우세요.
    } else if (isPlanSelected) {
      return _buildPlanList();
    } else if (isReviewSelected) {
      return Text("리뷰 데이터"); // 이 부분은 원하시는 데이터로 채우세요.
    } else {
      return SizedBox();
    }
  }

  Widget _buildPlanList() {
    return ListView.builder(
      itemCount: userPlans.length,
      itemBuilder: (context, index) {
        // 날짜를 파싱하고 원하는 형식으로 변환합니다.
        DateTime startDate =
            DateTime.parse(userPlans[index]['schedule'][0]['start_date']);
        String formattedDate = DateFormat('yy.MM.dd')
            .format(startDate); // 'yyyy-MM-dd' -> 'yy.MM.dd'

        return Card(
          elevation: 4.0, // 카드에 그림자 효과를 줍니다.
          margin: EdgeInsets.symmetric(
              horizontal: 10, vertical: 6), // 카드 간의 여백을 설정합니다.
          child: ListTile(
            leading: Icon(Icons.map,
                color: Theme.of(context).primaryColor), // 리스트 타일 앞에 아이콘을 추가합니다.
            title: Text(
              userPlans[index]['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold, // 제목의 폰트 두께를 굵게 설정합니다.
              ),
            ),
            subtitle: Text("여행 시작일 : $formattedDate"), // 변환된 날짜를 부제목에 추가합니다.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlanDetailsPage(schedule: userPlans[index]['schedule']),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
