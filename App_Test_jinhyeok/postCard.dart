import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class PostCard extends StatefulWidget {
  int number;

  PostCard({required this.number});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
        child: Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30), //여백을 추가
        child: Container(
          height: 240,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              print('Page changed to: $page');
            },
            itemCount: 3, // 페이지 수
            itemBuilder: (context, position) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), // 테두리
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://source.unsplash.com/random/${position + 1}'), // 이미지
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      DotsIndicator(
        dotsCount: 3, // 페이지 수를 설정하세요.
        position: _currentPage,
        decorator: DotsDecorator(
          activeColor: Colors.red,
        ),
      ),
      Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10), //여백을 추가
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5), // 투명도
            borderRadius: BorderRadius.circular(35), // 테두리
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 10, // 위에서부터의 거리
                left: 10, // 왼쪽에서부터의 거리
                child: Text(
                  '요즘 자주가는 여행지',
                  style: TextStyle(
                    fontSize: 20, // 글자 크기
                    color: Colors.black, // 글자 색상
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
