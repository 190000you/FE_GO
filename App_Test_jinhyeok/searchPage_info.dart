import 'package:flutter/material.dart';

class PlaceDetailPage extends StatelessWidget {
  final Map<String, dynamic> placeDetails;

  PlaceDetailPage({Key? key, required this.placeDetails}) : super(key: key);

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
            // 사진을 넣을 공간
            Placeholder(
              fallbackHeight: 200, // 이미지의 높이
            ),
            SizedBox(height: 20),

            // !!
            // API 기능 넣기
            // 항목(ICON): 찜 / 일정추가 / 리뷰쓰기 / 공유하기
            //
            // 1. 정보 추가 : location, 평균 체류 시간 등
            // 2. 구글 지도 API 추가
            // 3. 다른 사용자의 장소에 대한 리뷰 내용 추가 (API)
            // !!

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
