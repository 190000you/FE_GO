import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceDetailPage extends StatelessWidget {
  final Map<String, dynamic> placeDetails;

  PlaceDetailPage({Key? key, required this.placeDetails}) : super(key: key);
  final storage = FlutterSecureStorage();

  // 찜하기 API
  Future<void> fetchLikePlace(String placeName) async {
    String? userId = await storage.read(key: "login_id");
    String? userAccessToken = await storage.read(key: "login_access_token");

    final response = await http.post(
      Uri.parse('http://43.203.61.149/user/likeplace'),
      headers: {
        'Authorization': 'Bearer $userAccessToken',
      },
      body: jsonEncode({'placeName': placeName}),
    );

    if (response.statusCode == 201) {
      final snackBar = SnackBar(content: Text("찜하기 성공"));
    } else {
      print("찜하기 실패: ${response.statusCode}");
    }
  }

  // 사용자의 플랜 목록을 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchPlansForUser() async {
    String? userId = await storage.read(key: "login_id");

    final response = await http.get(
      Uri.parse('http://43.203.61.149/plan/plan/'),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> plans = responseData['results'];
      List<Map<String, dynamic>> userPlans = [];
      for (var plan in plans) {
        if (plan['user'].toString() == userId) {
          userPlans.add(plan);
        }
      }
      return userPlans;
    } else {
      throw Exception('Failed to load plans');
    }
  }

  // 플랜에 장소 추가 함수
  Future<void> addToPlan(String planId, String placeId) async {
    final response = await http.post(
      Uri.parse('http://43.203.61.149/plan/schedule/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'start_date': null,
        'end_date': null,
        'place': placeId,
        'plan': planId,
      }),
    );

    if (response.statusCode == 201) {
      print("Plan updated successfully");
    } else {
      print("Failed to update plan");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tagWidgets = placeDetails['tag']
        .map<Widget>((tag) => Chip(
              label: Text(
                tag['name'],
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(placeDetails['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Placeholder(fallbackHeight: 200),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    fetchLikePlace(placeDetails['name']); // 찜하기 API 실행
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.favorite_border, size: 24),
                      SizedBox(height: 4),
                      Text('찜하기', style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      List<Map<String, dynamic>> plans =
                          await fetchPlansForUser();
                      String selectedPlanId = await _showPlanSelector(
                          context, plans); // 사용자가 플랜을 선택하게 하는 UI
                      if (selectedPlanId.isNotEmpty) {
                        String placeId = placeDetails['id'].toString();
                        await addToPlan(selectedPlanId, placeId);
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add_circle_outline, size: 24),
                      SizedBox(height: 4),
                      Text('플랜 추가', style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('리뷰 작성 버튼 클릭');
                    // 리뷰 작성 기능 수행
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.edit, size: 24),
                      SizedBox(height: 4),
                      Text('리뷰 작성', style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('공유 버튼 클릭');
                    // 공유하기 기능 수행
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.share, size: 24),
                      SizedBox(height: 4),
                      Text('공유', style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(thickness: 1),
            SizedBox(height: 5),
            _buildDetailItem('분류', placeDetails['classification']),
            SizedBox(height: 20),
            _buildDetailItem('주차 여부', placeDetails['parking'] ? '가능' : '불가능'),
            SizedBox(height: 20),
            _buildDetailItem('자세한 정보', placeDetails['info']),
            SizedBox(height: 20),
            _buildDetailItem('전화번호', placeDetails['call']),
            SizedBox(height: 20),
            Text(
              '태그',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: tagWidgets,
            ),
            SizedBox(height: 20),
            _buildDetailItem('체류 시간', placeDetails['time']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Future<String> _showPlanSelector(
      BuildContext context, List<Map<String, dynamic>> plans) async {
    if (plans.isEmpty) {
      // 계획이 없을 경우 사용자에게 알림
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("알림"),
          content: Text("사용 가능한 플랜이 없습니다."),
          actions: <Widget>[
            TextButton(
              child: Text("닫기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return '';
    } else {
      final selectedPlanId = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('플랜을 선택하세요'),
            children: plans.map((Map<String, dynamic> plan) {
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(context, plan['id'].toString()),
                child: Text(plan['name']),
              );
            }).toList(),
          );
        },
      );
      return selectedPlanId ?? ''; // Null일 경우 빈 문자열 반환
    }
  }
}
