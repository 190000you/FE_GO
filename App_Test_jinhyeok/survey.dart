import 'package:flutter/material.dart';
import 'package:go_test_ver/chatBot.dart';

import 'package:introduction_screen/introduction_screen.dart'; // 사용자별 한 번 설무조사 UI
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장

// 점수 매핑
Map<int, int> createScoreMap() {
  return {
    0: 0,
    1: 1,
    2: 3,
    3: 5,
    4: 7,
    5: 9,
    6: 10,
  };
}

class SurveyScreen extends StatefulWidget {
  final String access;
  final String refresh;

  SurveyScreen(this.access, this.refresh);

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  static final storage = FlutterSecureStorage();
  late String access;
  late String refresh;

  void initState() {
    super.initState();
    access = widget.access; // 이전 페이지에서 Access Token 받아서 저장
    refresh = widget.refresh; // 이전 페이지에서 Refresh Token 받아서 저장

    print("homeScreen access : " + access);
    print("homeScreen refresh : " + refresh);
  }

  String selectedGender = ""; // 성별(String형) : M / W
  int selectedAge = 10; // 나이(int형) : 10, 20, 30...

  int selectedNature = 3; // 1. 자연<->도시
  int selectedSleep = 3; // 2. 숙박<->당일치기
  int selectedNew = 3; // 3. 새로운 지역 <-> 익숙한 지역
  int selectedExpensive = 3; // 4. 편하고 비싼 숙소 <-> 불편하고 싼 숙소 선택
  int selectedRest = 3; // 5. 휴식 <-> 체험 선택
  int selectedPopular = 3; // 6. 잘 알려지지 않은 장소 <-> 잘 알려진 장소 선택
  int selectedJ = 3; // 7. 계힉적인 <-> 즉흥적인 선택
  int selectedPhoto = 3; // 8. 사진으로 남기기 <-> 기억으로 남기기
  int selectedWith = 3; // 9. 동반자 적음 <-> 동반자 많음

  var scoreNature = createScoreMap(); // 1. 자연<->도시
  var scoreSleep = createScoreMap(); // 2. 숙박<->당일치기
  var scoreNew = createScoreMap(); // 3. 새로운 지역 <-> 익숙한 지역
  var scoreExpensive = createScoreMap(); // 4. 편하고 비싼 숙소 <-> 불편하고 싼 숙소 선택
  var scoreRest = createScoreMap(); // 5. 휴식 <-> 체험 선택
  var scorePopular = createScoreMap(); // 6. 잘 알려지지 않은 장소 <-> 잘 알려진 장소 선택
  var scoreJ = createScoreMap(); // 7. 계힉적인 <-> 즉흥적인 선택
  var scorePhoto = createScoreMap(); // 8. 사진으로 남기기 <-> 기억으로 남기기
  var scoreWith = createScoreMap(); // 9. 동반자 적음 <-> 동반자 많음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      // 스크롤 가능한 레이아웃 추가
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 성별 설문조사
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      '성별:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  RadioListTile<String>(
                    title: Text('남자'),
                    value: 'M',
                    groupValue: selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('여자'),
                    value: 'W',
                    groupValue: selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // 나이 설문조사
            Card(
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      '나이:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Slider(
                    min: 10,
                    max: 100,
                    divisions: 9,
                    value: selectedAge.toDouble(),
                    label: selectedAge.toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        selectedAge = newValue.round();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            // 1. 자연<->도시 (장소)
            buildOptionSection(
              '자연',
              '도시',
              selectedNature,
              7,
              (index) {
                setState(() {
                  selectedNature = index;
                });
              },
            ),
            SizedBox(height: 70),
            // 2. 숙박<->당일치기 (기간)
            buildOptionSection(
              '숙박',
              '당일치기',
              selectedSleep,
              7,
              (index) {
                setState(() {
                  selectedSleep = index;
                });
              },
            ),
            SizedBox(height: 70),
            // 3. 새로운 지역 <-> 익숙한 지역 (지역)
            buildOptionSection(
              '새로운 장소',
              '익숙한 장소',
              selectedNew,
              7,
              (index) {
                setState(() {
                  selectedNew = index;
                });
              },
            ),
            SizedBox(height: 70),
            // 4. 편하고 비싼 숙소 <-> 불편하고 싼 숙소 선택 (숙소)
            buildOptionSection(
              '편하지만 비싼 숙소',
              '불편하지만 싼 숙소',
              selectedExpensive,
              7,
              (index) {
                setState(() {
                  selectedExpensive = index;
                });
              },
            ),
            SizedBox(height: 70),
            // 5. 휴식 <-> 체험 선택 (활동)
            buildOptionSection(
              '휴식',
              '체험',
              selectedRest,
              7,
              (index) {
                setState(() {
                  selectedRest = index;
                });
              },
            ),
            SizedBox(height: 70),
            // 6. 잘 알려지지 않은 장소 <-> 잘 알려진 장소 선택 (방문지)
            buildOptionSection(
              '구석진 장소',
              '알려진 장소',
              selectedPopular,
              7,
              (index) {
                setState(() {
                  selectedPopular = index;
                });
              },
            ),
            SizedBox(height: 70),
            // 7. 계힉적인 <-> 즉흥적인 선택 (계획)
            buildOptionSection(
              '계획적인',
              '즉흥적인',
              selectedJ,
              7,
              (index) {
                setState(() {
                  selectedJ = index;
                });
              },
            ),
            SizedBox(height: 70),
            // 8. 사진으로 남기기 <-> 기억으로 남기기 (사진)
            buildOptionSection(
              '사진으로 남기기',
              '기억으로 남기기',
              selectedPhoto,
              7,
              (index) {
                setState(() {
                  selectedPhoto = index;
                });
              },
            ),
            SizedBox(height: 70),
            // 9. 동반자 적음 <-> 동반자 많음 (동반자)
            buildOptionSection(
              '동반자 적음',
              '동반자 많음',
              selectedWith,
              7,
              (index) {
                setState(() {
                  selectedWith = index;
                });
              },
            ),
            // "제출" 버튼
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // 선택된 점수 출력 및 다른 로직 구현...

                // 사용자별 설문조사 데이터 입력 API 사용...
                final snackBar = SnackBar(content: Text("성공적으로 제출했습니다."));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // 챗봇 페이지 또는 메인 페이지로 이동
                // 메인 페이지로 이동하는게 더 맞을듯?
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatBotPage(access, refresh)), // 다음 화면으로 이동
                );
              },
              child: Text(
                '제출',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // 버튼의 텍스트 색상
                shape: RoundedRectangleBorder(
                  // 버튼의 모양을 정의
                  borderRadius: BorderRadius.zero, // 네모난 모양으로 만들기
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 50, vertical: 20), // 버튼 내부 패딩
                elevation: 5, // 버튼의 그림자 깊이
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    ));
  }

  Widget buildOptionSection(String leftText, String rightText,
      int selectedOption, int optionsCount, void Function(int) onTap) {
    // 원의 크기 설정을 위한 배열
    List<double> sizes = [40, 36, 32, 28, 32, 36, 40]; // 크기를 조정합니다.

    return Column(
      children: [
        // 라벨 배치 조정
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 라벨들을 양 끝으로 분배
          children: [
            // "자연" 라벨에 대한 컨테이너, 왼쪽에서 5픽셀 떨어짐
            Container(
              margin: EdgeInsets.only(left: 20), // 왼쪽 여백 추가
              child: Text(leftText, style: TextStyle(fontSize: 16)),
            ),
            // "도시" 라벨에 대한 컨테이너, 오른쪽에서 5픽셀 떨어짐
            Container(
              margin: EdgeInsets.only(right: 20), // 오른쪽 여백 추가
              child: Text(rightText, style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
        SizedBox(height: 12), // 라벨과 원 사이의 간격 조정
        // 원들 배치
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // 공간을 더 넓게 하기 위해 변경
          children: List.generate(
            optionsCount,
            (index) => GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                width: sizes[index], // 인덱스에 따른 크기 할당
                height: sizes[index], // 인덱스에 따른 크기 할당
                margin: EdgeInsets.symmetric(horizontal: 4), // 원 사이의 간격 조절
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedOption == index
                      ? Colors.blue
                      : Colors.grey.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
