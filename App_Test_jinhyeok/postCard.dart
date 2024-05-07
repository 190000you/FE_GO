import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:http/http.dart';

import 'advertisement.dart'; // 광고 창
import 'package:geolocator/geolocator.dart'; // 실시간 위치 정보
import 'package:http/http.dart' as http; // API 사용
import 'dart:convert'; // API 호출 : 디코딩

class PostCard extends StatefulWidget {
  int number;

  PostCard({required this.number});

  @override
  _PostCardState createState() => _PostCardState();
}
// 밑에있는 페이지 컨트롤에 필요함, 따로 호출하지 않음 메인 페이지의 사진이 @초 마다 지나간다는 걸 컨트롤 할 때

class _PostCardState extends State<PostCard> {
  // 이미지 컨트롤 타이머
  PageController _pageController = PageController();
  Timer? _timer;
  double _currentPage = 0;

  // 페이지 이동 시간
  @override
  void initState() {
    super.initState();
    getLocation(); // 1. 사용자 위치 확인
    // 2.
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_pageController.page == _pageController.initialPage + 2) {
        _pageController.animateToPage(
          _pageController.initialPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 제공하는 서비스 - 클릭 이벤트 코드
  void onServiceTap(int index) {
    // List[Navigator]
    // 여기서 index별로 다른 이벤트를 실행할 수 있습니다.
    // 예를 들어, Navigator.push로 각 서비스의 상세 페이지로 이동하게 할 수 있습니다.
    print('Service $index clicked');
  }

  // 제공하는 서비스 - Text 수정
  final List<String> serviceTitles = [
    '여행 정보',
    '챗봇 추천',
    '플랜 작성',
    '링크 공유',
  ];

  // 네이버 지도 Mapping
  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "yo5tmuo7vz", // 개인 클라이언트 아이디
    "X-NCP-APIGW-API-KEY":
        "oGcKmx1VAWZPChzVZGiaFec1jmmkrlVElCofTB5i" // 개인 시크릿 키
  };

  String weather = ""; // 1. 날씨
  String temperature = ""; // 2. 온도
  String humidity = ""; // 3. 습도

  // 현재 위치 + 행정 구역명 + 날씨 정보
  Future<void> getLocation() async {
    // 1. 현재 위치 받기 (위도 + 경도)
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String lat = position.latitude.toString(); // 위도
    String lon = position.longitude.toString(); // 경도
    print("위도 : " + lat);
    print("경도 : " + lon);
    // print(position);

    // 2. 위도 경도 -> 행정 구역으로 바꿈 // 오류 발생

    // 3. 날씨 정보 얻기
    String openweatherkey = "0e047ef5cce50504edc52d08b01c1933";
    var str =
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openweatherkey&units=metric';
    print("날씨 정보 : " + str);

    final response = await http.get(
      Uri.parse(str),
    );

    if (response.statusCode == 200) {
      var data = response.body;
      var dataJson = jsonDecode(data); // string to json
      print('data = $data');
      /*
      print(dataJson['weather'][0]['main'] +
          ' ' +
          dataJson['main']['temp'].toString());
      */
      weather = dataJson['weather'][0]['main'];
      temperature = dataJson['main']['temp'].toString();
      humidity = dataJson['main']['humidity'].toString();
    } else {
      print('response status code = ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // 1. 움직이는 캐러셀
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 2.0, // 가로 길이
              child: Stack(
                alignment: Alignment.bottomCenter, // 인디케이터
                children: [
                  Container(
                    height: 240,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        print('Page changed to: $page');
                      },
                      itemCount: 3,
                      itemBuilder: (context, position) {
                        if (position == 0) {
                          // 첫 번째 페이지일 때 광고 페이지 동작하는 코드
                          return GestureDetector(
                            onTap: () {
                              // 광고창 오픈
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdvertisementPage(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  2.0, // 페이지 너비 딱맞게
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://source.unsplash.com/random/${position + 1}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        } else {
                          // 두 번째 페이지 이후에는 일반적인 Container 반환 2~ 3번쨰 페이지 또한 위와 같은 방법으로 추가가
                          return Container(
                            width: MediaQuery.of(context).size.width *
                                2.0, // 페이지 너비 딱맞게
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://source.unsplash.com/random/${position + 1}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: _currentPage
                        .toInt(), // _currentPage(현재 페이지)를 int로 변경하고 1로
                    decorator: DotsDecorator(
                      activeColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          // 1.5 : Text 문구
          Container(
            color: Colors.white, // 배경색을 하얀색으로 설정
            child: SizedBox(
              width: double.infinity, // 가로로 꽉 차게
              child: Center(
                // 가운데 정렬
                child: Column(
                  children: [
                    Text(
                      '가볼까가 추천하는 여행지', // 한글 제목
                      style: TextStyle(
                        fontSize: 16, // 글씨 크기 조절
                        fontWeight: FontWeight.bold, // 글씨 두껍게
                        color: Colors.black, // 글씨 색상은 검은색
                      ),
                    ),
                    SizedBox(height: 10), // 한글과 영문 제목 사이의 간격을 조정
                    Text(
                      'Go to Trip?', // 영문 제목
                      style: TextStyle(
                        fontSize: 24, // 글씨 크기 조절
                        fontWeight: FontWeight.bold, // 글씨 두껍게
                        color: Colors.black, // 글씨 색상은 검은색
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          // 2. 동그라미 광고판
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 200,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // 원이 5개 있음
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // 첫 번째 원
                    return GestureDetector(
                      onTap: () {
                        // 0번 원을 눌렀을때 할 행동(검색)
                      },
                      child: Container(
                        // 첫번째 원
                        width: 130, // 원의 너비
                        margin: EdgeInsets.symmetric(horizontal: 5), // 원 사이의 간격
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey, // 회색으로 채우기
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 40,
                              color: Colors.white, // 아이콘 색상
                            ),
                            SizedBox(height: 10),
                            Text(
                              '검색',
                              style: TextStyle(
                                color: Colors.white, // 텍스트 색상
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // 나머지 원들 이후 원들은 아래 코드를 넣어주면 됨
                    return GestureDetector(
                      onTap: () {
                        // 각 원을 탭했을 때의 동작 추가 이후
                      },
                      child: Container(
                        width: 130, // 각 원의 너비
                        margin: EdgeInsets.symmetric(
                            horizontal: 5), // 각 원 사이의 간격 조정
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://source.unsplash.com/random'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          // 2.5 : Text 문구
          Container(
            color: Colors.white, // 배경색을 하얀색으로 설정
            child: SizedBox(
              width: double.infinity, // 가로로 꽉 차게
              child: Center(
                // 가운데 정렬
                child: Column(
                  children: [
                    Text(
                      '제공하는 서비스', // 한글 제목
                      style: TextStyle(
                        fontSize: 16, // 글씨 크기 조절
                        fontWeight: FontWeight.bold, // 글씨 두껍게
                        color: Colors.black, // 글씨 색상은 검은색
                      ),
                    ),
                    SizedBox(height: 10), // 한글과 영문 제목 사이의 간격을 조정
                    Text(
                      '가볼까?', // 영문 제목
                      style: TextStyle(
                        fontSize: 24, // 글씨 크기 조절
                        fontWeight: FontWeight.bold, // 글씨 두껍게
                        color: Colors.black, // 글씨 색상은 검은색
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          // 3. 제공하는 서비스
          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: serviceTitles.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      onServiceTap(index); // 서비스 클릭 이벤트를 실행합니다.
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          serviceTitles[index], // 서비스별 고유한 텍스트
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          // 3.5 : Text 문구
          Container(
            color: Colors.white, // 배경색을 하얀색으로 설정
            child: SizedBox(
              width: double.infinity, // 가로로 꽉 차게
              child: Center(
                // 가운데 정렬
                child: Column(
                  children: [
                    Text(
                      '현재 위치로 여행 장소 찾기', // 한글 제목
                      style: TextStyle(
                        fontSize: 16, // 글씨 크기 조절
                        fontWeight: FontWeight.bold, // 글씨 두껍게
                        color: Colors.black, // 글씨 색상은 검은색
                      ),
                    ),
                    SizedBox(height: 10), // 한글과 영문 제목 사이의 간격을 조정
                    // 오류!! 데이터 전달 보다 앱 UI 빌드가 더 빠름
                    // -> 로그인할 때, 미리 날씨 API를 설정
                    // -> 데이터를 전달
                    // -> 그걸 받아내면 될듯한데
                    Text(
                      '$weather   $temperature°C   $humidity%',
                      style: TextStyle(
                        fontSize: 24, // 글씨 크기 조절
                        fontWeight: FontWeight.bold, // 글씨 두껍게
                        color: Colors.black, // 글씨 색상은 검은색
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          // 4. 현재 위치 표시
          Container(
            margin: EdgeInsets.all(8.0),
            width: double.infinity, // 필요에 따라 너비 조정
            height: 200, // 필요에 따라 높이 조정
            decoration: BoxDecoration(
              color: Colors.blue[300], // 박스의 배경색 설정
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 20, // 위치 필요에 따라 조정
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "대구광역시 신당동", // 사용 가능하다면 동적 위치 데이터로 교체
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
