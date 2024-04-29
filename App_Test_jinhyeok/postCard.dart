import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dots_indicator/dots_indicator.dart';

import 'advertisement.dart'; // 광고 창

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

  @override
  void initState() {
    super.initState();
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

  // 서비스 클릭 이벤트를 처리하기 위한 함수
  void onServiceTap(int index) {
    // List[Navigator]
    // 여기서 index별로 다른 이벤트를 실행할 수 있습니다.
    // 예를 들어, Navigator.push로 각 서비스의 상세 페이지로 이동하게 할 수 있습니다.
    print('Service $index clicked');
  }

  // 서비스 텍스트를 위한 리스트
  final List<String> serviceTitles = [
    '여행 정보',
    '챗봇 추천',
    '플랜 작성',
    '링크 공유',
  ];

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
          // 4. 제공하는 서비스
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
          SizedBox(height: 10),
          Container(
            height: 10,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
