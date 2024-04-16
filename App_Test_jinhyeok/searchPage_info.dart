import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart'; // Google Fonts 패키지를 가져옵니다.
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장
import 'package:http/http.dart' as http; // API 사용
import 'dart:convert'; // API 호출 : 디코딩

class PlaceDetailPage extends StatelessWidget {
  final Map<String, dynamic> placeDetails;

  String placeName = "";
  PlaceDetailPage({Key? key, required this.placeDetails}) : super(key: key);

  // 찜하기 API
  Future<void> fetchLikePlace(String placeName) async {
    // storage 생성
    final storage = new FlutterSecureStorage();

    String? userId = await storage.read(key: "login_id");
    String? userAccessToken = await storage.read(key: "login_access_token");
    String? userRefreshToken = await storage.read(key: "login_refresh_token");

    print("MainPage userId : " + (userId ?? "Unknown"));
    print("MainPage access Token : " + (userAccessToken ?? "Unknown"));
    print("MainPage refresh Token : " + (userRefreshToken ?? "Unknown"));

    // url에 "userId" + "access Token" 넣기
    final response = await http.post(
      Uri.parse('http://43.203.61.149/user/likeplace'), // API 엔드포인트
      // 헤더에 Authorization 추가해서 access Token값 넣기
      headers: {
        'Authorization': 'Bearer $userAccessToken',
      },
      body: placeName,
    );

    // !! 오류 !!
    // 인증 성공
    if (response.statusCode == 201) {
      print("인증 성공");
      final snackBar = SnackBar(content: Text("찜하기 성공"));
    } else {
      print("Failed to load user details");
    }
    // 상태 업데이트 써야하나?
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

    placeName = placeDetails["name"];
    print("placeName = " + placeName);

    return Scaffold(
      appBar: AppBar(
        title: Text(placeDetails['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Placeholder(
              fallbackHeight: 200,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    fetchLikePlace(placeName); // 찜하기 API 실행
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
                  onTap: () {
                    print('플랜에 추가 버튼 클릭');
                    // 플랜에 추가 기능 수행
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
}
