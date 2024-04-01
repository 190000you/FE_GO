import 'package:flutter/material.dart';
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
  String _searchResult = '';

  Future<void> fetchSearchResult(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResult = "검색어를 입력해주세요.";
      });
      return;
    }

    var body = jsonEncode({'name': query});
    final response = await http.post(
      Uri.parse('http://43.203.61.149/place/find/'),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      List placesByName = data['places_by_name'];
      List placesByTag = data['places_by_tag'];

      Set<String> matchedNames = {}; // 중복을 방지

      // "places_by_name"에서 "name" 필드가 검색어를 포함하는 장소의 이름을 찾기
      placesByName.forEach((place) {
        if ((place['name'] as String).contains(query)) {
          matchedNames.add(place['name']);
        }
      });

      // "places_by_tag"에서 "tag" 배열 내에 검색어를 포함하는 태그가 있는 장소의 이름을 찾기
      placesByTag.forEach((place) {
        var tags = place['tag'] as List;
        for (var tag in tags) {
          if ((tag['name'] as String).contains(query)) {
            matchedNames.add(place['name']);
            break; =
          }
        }
      });

      String resultNames = matchedNames.join('\n');

      setState(() {
        _searchResult = resultNames;
      });
    } else {
      print('Failed to load search result: ${response.statusCode}');
      setState(() {
        _searchResult =
            'Failed to load search result. Error code: ${response.statusCode}';
      });
    }
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                  if (query.isNotEmpty) {
                    fetchSearchResult(query);
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
          ],
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
            child: Center(
              child: Text(
                _searchResult,
                style: TextStyle(fontSize: 24),
              ),
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
}
