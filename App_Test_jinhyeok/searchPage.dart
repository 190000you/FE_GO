import 'package:flutter/material.dart';

import 'dart:convert'; // API 호출 : 디코딩
import 'package:http/http.dart' as http; // API 호출 2

// Search API(1)
class searchAPI {
  String? name;

  searchAPI({this.name});

  searchAPI.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

// Search API(2) : 함수 호출 및 API URL 연결
Future<void> fetchSearchAPI(name, context) async {
  // 데이터 저장 변수 : searchAPI
  final searchUser = searchAPI(
    name: name,
  );

  // API 연결
  final response = await http.post(
    Uri.parse('http://43.203.61.149/place/find/'),
    headers: {"Accept": "application/json"},
    body: searchUser.toJson(),
  );

  // 로그인 처리 과정

  // 로그인 성공 & 실패
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse =
        jsonDecode(response.body); // JSON 데이터 피싱
    String message = jsonResponse['message']; // 응답 메시지 확인
    if (message == "login success") {
      String access = jsonResponse['tag']['name'];

      print(access);

      // 로그인 성공
      final snackBar = SnackBar(content: Text("로그인 성공"));
      // 메인 페이지로 이동
      //Navigator.push(
      // context,
      // MaterialPageRoute(builder: (context) => MainPage(access)), // 다음 화면으로 이동
      //    );
    } else {
      final snackBar = SnackBar(content: Text('Token 인증에 실패했습니다.'));
    }
  } else {
    // 로그인 실패 : 아이디, 비밀번호 입력 X
    final snackBar = SnackBar(content: Text('아이디와 비밀번호를 정확하게 입력해주세요.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // throw Exception('회원가입 실패: ${response.statusCode}');
  }
}

// 검색 결과 API(1)
class SearchResult {
  final String name;
  final String? image;
  final String classification;
  final bool parking;
  final String info;
  final String call;
  final double hardness;
  final double latitude;
  final List<String> tags;
  final String time;
  final List<String> reviews;

  SearchResult({
    required this.name,
    this.image,
    required this.classification,
    required this.parking,
    required this.info,
    required this.call,
    required this.hardness,
    required this.latitude,
    required this.tags,
    required this.time,
    required this.reviews,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    List<String> tagNames = [];
    for (var tag in json['tag']) {
      tagNames.add(tag['name']);
    }

    return SearchResult(
      name: json['name'],
      image: json['image'],
      classification: json['classification'],
      parking: json['parking'],
      info: json['info'],
      call: json['call'],
      hardness: json['hardness'],
      latitude: json['latitude'],
      tags: tagNames,
      time: json['time'],
      reviews: List<String>.from(json['reviews']),
    );
  }
}

// 검색 결과 API(2)
Future<void> fetchSearchResults(String name, context) async {
  // context
  final searchUser = searchAPI(name: name);

  // 검색 단어 API
  final response = await http.post(
    Uri.parse('http://43.203.61.149/place/find/'),
    headers: {"Accept": "application/json"},
    body: searchUser.toJson(),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    // return jsonResponse.map((result) => SearchResult.fromJson(result)).toList();
    // 어떻게 return 할지는 자세하게 다루기
    // 1. 그 자리에서 검색된 결과 바로 업데이트 되게끔 만들기
    // ex) name = "막창"
    // -> 검색창 아래에 "막창"과 관련된 장소들 나열
  } else {
    final snackBar = SnackBar(content: Text('아이디와 비밀번호를 정확하게 입력해주세요.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        title: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "검색",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.map),
              onPressed: () {
                // Navigate to the map screen when the map icon is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          '검색어 : $query',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지도'),
      ),
      body: Center(
        child: Text('지도를 표시하는 위젯이나 페이지를 만들어 주세요.'),
      ),
    );
  }
}
