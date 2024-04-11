import 'package:flutter/material.dart';

// 내부 import
import 'package:go_test_ver/searchPage_info.dart'; // 경로 설정.

// 외부 import
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장
import 'package:http/http.dart' as http;
import 'dart:convert';


class SearchPage extends StatefulWidget {
  final String access;
  final String refresh;

  SearchPage(this.access, this.refresh);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  static final storage = FlutterSecureStorage();
  late String access;
  late String refresh;

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
      List placesByName = data['places_by_name']; // name으로 검색
      List placesByTag = data['places_by_tag']; // tag로 검색

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
        automaticallyImplyLeading: false,
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
              itemCount: _searchResults.length +
                  (_showMoreButton && _totalResultsCount > 5 ? 1 : 0),
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                if (index == _searchResults.length &&
                    _showMoreButton &&
                    _totalResultsCount > 5) {
                  return _buildMoreButton(); // "더보기" button as the last item
                }

                // Item widget code
                var item = _searchResults[index];
                var tags = item['tag'] != null && item['tag'].isNotEmpty
                    ? item['tag'].map((tag) => tag['name']).join(' ')
                    : ' ';
                var imageUrl =
                    item['image'] ?? 'https://via.placeholder.com/80';

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlaceDetailPage(placeDetails: item),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          imageUrl,
                          width: 60,
                          height: 60, // Correct height value
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Visibility(
                                  visible: tags.isNotEmpty,
                                  child: Text(
                                    tags,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
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
