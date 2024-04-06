import 'package:flutter/material.dart';
import 'package:flutter_application_2/searchPage_info.dart'; // 경로 설정.
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String query = '';
  final List<String> _tags = ['#태그'];
  List<Map<String, dynamic>> _searchResults = [];
  int _totalResultsCount = 0; // 검색 결과의 전체 개수를 저장할 변수
  bool _showMoreButton = true; // "더보기" 버튼을 표시할지 여부를 결정하는 변수

  Future<void> fetchSearchResult(String query, {bool fetchAll = false}) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _totalResultsCount = 0;
        _showMoreButton = true; // 검색어가 비어있으면 "더보기" 버튼을 다시 표시합니다.
      });
      return;
    }

    var body = jsonEncode({'name': query});
    final response = await http.post(
      Uri.parse('http://43.203.61.149/place/find/'), // 실제 API URL로 변경해주세요.
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      List placesByName = data['places_by_name'];
      List placesByTag = data['places_by_tag'];

      Set<Map<String, dynamic>> matchedPlaces = {};

      placesByName.forEach((place) {
        matchedPlaces.add(place);
      });

      placesByTag.forEach((place) {
        matchedPlaces.add(place);
      });

      _totalResultsCount = matchedPlaces.length;
      setState(() {
        _searchResults =
            fetchAll ? matchedPlaces.toList() : matchedPlaces.take(5).toList();
        _showMoreButton = !fetchAll; // "더보기"를 클릭하면 버튼을 숨깁니다.
      });
    } else {
      print('검색 실패 오류코드: ${response.statusCode}');
      setState(() {
        _searchResults = [];
        _totalResultsCount = 0;
        _showMoreButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨기기
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              onSubmitted: (value) => fetchSearchResult(query),
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: _tags.map((tag) => _buildChip(tag)).toList(),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: _searchResults.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    _searchResults[index]['name'],
                    style: TextStyle(fontSize: 24),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailPage(
                            placeDetails: _searchResults[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_showMoreButton && _totalResultsCount > 5) _buildMoreButton(),
        ],
      ),
    );
  }

  Widget _buildChip(String tag) {
    return InkWell(
      onTap: () => _scaffoldKey.currentState?.openDrawer(),
      child: Chip(
        label: Text(tag),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: OutlinedButton(
          child: Text('더보기'),
          onPressed: () => fetchSearchResult(query, fetchAll: true),
        ),
      ),
    );
  }
}
