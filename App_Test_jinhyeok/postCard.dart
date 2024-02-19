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
  bool _isIcon1Flash = false;
  bool _isIcon2Flash = false;
  bool _isIcon3Flash = false;

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
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              height: 240,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  print('Page changed to: $page');
                },
                itemCount: 3,
                itemBuilder: (context, position) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://source.unsplash.com/random/${position + 1}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            position: _currentPage,
            decorator: DotsDecorator(
              activeColor: Colors.red,
            ),
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildSelectableIcon(
                  Icons.favorite,
                  Colors.red,
                  _isIcon1Flash,
                  () {
                    setState(() {
                      _isIcon1Flash = true;
                    });

                    // Faster flash effect duration
                    Timer(Duration(milliseconds: 150), () {
                      setState(() {
                        _isIcon1Flash = false;
                      });
                    });
                    print('Icon 1 Clicked');
                  },
                ),
                buildSelectableIcon(
                  Icons.comment,
                  Colors.blue,
                  _isIcon2Flash,
                  () {
                    setState(() {
                      _isIcon2Flash = true;
                    });

                    // Faster flash effect duration
                    Timer(Duration(milliseconds: 150), () {
                      setState(() {
                        _isIcon2Flash = false;
                      });
                    });
                    print('Icon 2 Clicked');
                  },
                ),
                buildSelectableIcon(
                  Icons.share,
                  Colors.green,
                  _isIcon3Flash,
                  () {
                    setState(() {
                      _isIcon3Flash = true;
                    });

                    // Faster flash effect duration
                    Timer(Duration(milliseconds: 150), () {
                      setState(() {
                        _isIcon3Flash = false;
                      });
                    });
                    print('Icon 3 Clicked');
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Text(
                      '요즘 자주가는 여행지',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectableIcon(
    IconData icon,
    Color color,
    bool isFlash,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isFlash ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(10),
        child: Icon(
          icon,
          color: color,
          size: 30,
        ),
      ),
    );
  }
}

