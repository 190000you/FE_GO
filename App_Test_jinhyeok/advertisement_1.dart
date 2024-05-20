import 'package:flutter/material.dart';

class AdvertisementPage_1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('여름철 시원하게 보내기'), // AppBar 제목 설정
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 뒤로가기 기능
        ),
      ),
      body: SingleChildScrollView(
        // 스크롤 가능한 뷰
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 0. 대표 이미지 + 텍스트
            Image.network(
              'https://source.unsplash.com/random/', // 이미지 URL
              height: 240,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '여름철 시원하게 보내기', // 상단 텍스트
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // 텍스트를 중앙 정렬
              ),
            ),
            // Divider(),
            SizedBox(height: 20),
            // 1. 시원한 계곡
            // 1.1) 소제목
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Travel TIP 1. 시원한 계곡', // 세부 섹션 제목
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // 1.2) 이미지
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게
                  color: Colors.white, // 배경색을 흰색으로 설정
                ),
                clipBehavior: Clip.antiAlias, // 모서리가 둥글 때 이미지를 잘라냄
                child: Image.network(
                  'https://source.unsplash.com/random/', // 세부 정보 이미지 URL
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 1.3) 내용 1
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '미야코지마는 오리엔탈과 대만 사이에 있는 규슈 북부에 위치하여 최적 기후의 15분 이내 거리에 있습니다. 5월부터 9월까지 비교적 건조하며, 온도는 27도를 유지합니다.', // 세부 정보 설명
                style: TextStyle(fontSize: 16),
              ),
            ),
            // 1.4) 간격
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // 위 아래 패딩 조정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
                  SizedBox(width: 20), // 첫 번째와 두 번째 점 사이 간격
                  Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
                  SizedBox(width: 20), // 두 번째와 세 번째 점 사이 간격
                  Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
                ],
              ),
            ),
            // 1.5) 내용 2
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '미야코지마는 태평양에 있는 섬으로 해변 모습이 두 대륙 간의 자연 어울림을 보여줍니다. 이 지역이 외면된 것은 아니다메시테 활발한 그 이상의 인상을 남길 수 있는 최적의 배경을 제공한다.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            // 2. 실내 데이트
            // 2.1) 소제목
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Travel TIP 2. 실내 데이트', // 세부 섹션 제목
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // 2.2) 이미지
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게
                  color: Colors.white, // 배경색을 흰색으로 설정
                ),
                clipBehavior: Clip.antiAlias, // 모서리가 둥글 때 이미지를 잘라냄
                child: Image.network(
                  'https://source.unsplash.com/random/', // 세부 정보 이미지 URL
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 2.3) 내용 1
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '이곳에서 자연의 아름다움을 최대한으로 누리며 인생 사진도 남기지 말자.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // 위 아래 패딩 조정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
                  SizedBox(width: 20), // 첫 번째와 두 번째 점 사이 간격
                  Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
                  SizedBox(width: 20), // 두 번째와 세 번째 점 사이 간격
                  Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '일본정부에서 가장 아름다운 대국 \'일본무대\'로 2015년에 개도된 미야코지마는 일본 남은 연결하는 일본에서 가장 큰 다리로 그 도읍을 자랑하는 곳입니다.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            // 3. 수목원
            // 3.1) 소제목
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Travel TIP 3. 수목원', // 세부 섹션 제목
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // 3.2) 이미지
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게
                  color: Colors.white, // 배경색을 흰색으로 설정
                ),
                clipBehavior: Clip.antiAlias, // 모서리가 둥글 때 이미지를 잘라냄
                child: Image.network(
                  'https://source.unsplash.com/random/', // 세부 정보 이미지 URL
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 3.3) 내용 1
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '이곳에서 자연의 아름다움을 최대한으로 누리며 인생 사진도 남기지 말자.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // 위 아래 패딩 조정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
                  SizedBox(width: 20), // 첫 번째와 두 번째 점 사이 간격
                  Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
                  SizedBox(width: 20), // 두 번째와 세 번째 점 사이 간격
                  Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '일본정부에서 가장 아름다운 대국 \'일본무대\'로 2015년에 개도된 미야코지마는 일본 남은 연결하는 일본에서 가장 큰 다리로 그 도읍을 자랑하는 곳입니다.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
