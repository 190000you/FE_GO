// 내부 import
import 'package:go_test_ver/advertisement_2.dart';
import 'package:go_test_ver/advertisement_3.dart';

import 'advertisement_1.dart'; // 광고 창

// 외부 import
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:http/http.dart';
import 'package:google_fonts/google_fonts.dart'; // Google Fonts 패키지를 가져옵니다.

class PostCard extends StatefulWidget {
  final Map<String, dynamic> weatherData;
  final int number;

  PostCard({
    Key? key,
    required this.weatherData,
    required this.number,
  }) : super(key: key);

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
    // getLocation(); // 1. 사용자 위치 확인
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

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  @override
  Widget build(BuildContext context) {
    int conditionId = widget.weatherData['conditionId'] ?? 0;
    String temperature =
        widget.weatherData['temperature']?.toString() ?? 'unknown';
    String temperature_min =
        widget.weatherData['temperature_min']?.toString() ?? 'unknown';
    String temperature_max =
        widget.weatherData['temperature_max']?.toString() ?? 'unknown';
    String humidity = widget.weatherData['humidity']?.toString() ?? 'unknown';
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
                        // 1. 여름철 시원하게 보내기 광고
                        if (position == 0) {
                          return GestureDetector(
                            onTap: () {
                              // 첫 번째 광고 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdvertisementPage_1(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  2.0, // 페이지 너비 딱맞게
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                // 랜덤 이미지 -> 이미지 바꾸기
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://source.unsplash.com/random/${position + 1}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }
                        // 2. 인기 휴양지
                        else if (position == 1) {
                          return GestureDetector(
                            onTap: () {
                              // 두 번째 광고 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdvertisementPage_2(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  2.0, // 페이지 너비 딱맞게
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                // 랜덤 이미지
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://source.unsplash.com/random/${position + 1}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }
                        // 3. 최근 떠오르는 장소
                        else if (position == 2) {
                          return GestureDetector(
                            onTap: () {
                              // 두 번째 광고 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdvertisementPage_3(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  2.0, // 페이지 너비 딱맞게
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                // 랜덤 이미지
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://source.unsplash.com/random/${position + 1}'),
                                  fit: BoxFit.cover,
                                ),
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
                      style: GoogleFonts.oleoScript(
                        fontSize: 16, // 글씨 크기 조절
                        fontWeight: FontWeight.bold, // 글씨 두껍게
                        color: Colors.black, // 글씨 색상은 검은색
                      ),
                    ),
                    SizedBox(height: 10), // 한글과 영문 제목 사이의 간격을 조정
                    Text(
                      'Go to Trip?', // 영문 제목
                      // style: GoogleFonts.oleoScript(fontSize: 36),
                      style: GoogleFonts.oleoScript(
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
                              style: GoogleFonts.oleoScript(
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
                      style: GoogleFonts.oleoScript(
                        fontSize: 16, // 글씨 크기 조절
                        fontWeight: FontWeight.bold, // 글씨 두껍게
                        color: Colors.black, // 글씨 색상은 검은색
                      ),
                    ),
                    SizedBox(height: 10), // 한글과 영문 제목 사이의 간격을 조정
                    Text(
                      '가볼까?', // 영문 제목
                      style: GoogleFonts.oleoScript(
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
                          style: GoogleFonts.oleoScript(
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
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      '현재 위치로 여행 장소 찾기', // 제목
                      style: GoogleFonts.oleoScript(
                        fontSize: 16, // 글자 크기
                        fontWeight: FontWeight.bold, // 글자 두께
                        color: Colors.black, // 글자 색상
                      ),
                    ),
                    SizedBox(height: 10), // 제목과 아이콘 사이의 간격
                    SizedBox(height: 10), // 아이콘과 날씨 정보 사이의 간격
                    Text(
                      // '${getWeatherIcon(conditionId)}   ${widget.weatherData['temperature_min']}~${widget.weatherData['temperature_max']}°C   ${widget.weatherData['humidity']}%', // 날씨 정보
                      '${getWeatherIcon(conditionId)}   ${widget.weatherData['temperature']}°C   ${widget.weatherData['humidity']}%', // 날씨 정보
                      style: GoogleFonts.oleoScript(
                        fontSize: 24, // 글자 크기
                        fontWeight: FontWeight.bold, // 글자 두께
                        color: Colors.black, // 글자 색상
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
                      style: GoogleFonts.oleoScript(
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
