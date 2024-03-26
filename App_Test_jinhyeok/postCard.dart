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

class _PostCardState extends State<PostCard> { // 이미지 컨트롤 타이머
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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
          SizedBox(height: 10), // 위의 사진과 밑의 컨텐츠 사이 간격
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 200,
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
                        width: 180, // 원의 너비
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
                              size: 50,
                              color: Colors.white, // 아이콘 색상
                            ),
                            SizedBox(height: 10),
                            Text(
                              '검색',
                              style: TextStyle(
                                color: Colors.white, // 텍스트 색상
                                fontSize: 20,
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
                        width: 180, // 각 원의 너비
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
        ],


      ),
    );
  }
}
