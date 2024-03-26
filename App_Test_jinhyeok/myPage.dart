// 마이 페이지
import 'package:flutter/material.dart';

// 이후 import로 더 추가할 예정
import 'package:flutter_slidable/flutter_slidable.dart'; // 슬라이더 (delete / share)
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // 아이템 정렬 애니메이션

class MyPage extends StatefulWidget {
  final String access;
  final String refresh;

  MyPage(this.access, this.refresh);

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  // 찜목록 / 플랜 / 리뷰 버튼 선택 활성화
  bool isFavoriteSelected = false;
  bool isPlanSelected = false;
  bool isReviewSelected = false;
  int gridViewCrossAxisCount = 3; // 찜목록 1줄에 n개 개수
  // 나중에 토글할 수 있도록 수정.

  void initState() {
    super.initState();
    print("myPage access : " + widget.access);
    print("myPage refresh : " + widget.refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 프로필 사진 수정
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                // 1-1) 이미지 보여주는 모양 + 이미지 선택
                CircleAvatar(
                  radius: 50,
                  // backgroundImage: AssetImage("assets/profile_image.png"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 2. 사용자 이름 설정
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              initialValue: "사용자 이름",
              textAlign: TextAlign.center,
              onChanged: (value) {},
            ),
          ),
          // 3. 찜목록 / 플랜 / 리뷰 버튼
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _toggleSelection(1),
                  style: _buttonStyle(isFavoriteSelected),
                  child: _buttonChild("찜목록", isFavoriteSelected),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _toggleSelection(2),
                  style: _buttonStyle(isPlanSelected),
                  child: _buttonChild("플랜", isPlanSelected),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _toggleSelection(3),
                  style: _buttonStyle(isReviewSelected),
                  child: _buttonChild("리뷰", isReviewSelected),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildSelectedInfo(),
        ],
      ),
    );
  }

  // 찜목록 / 플랜 / 리뷰 토글
  void _toggleSelection(int index) {
    setState(() {
      isFavoriteSelected = index == 1;
      isPlanSelected = index == 2;
      isReviewSelected = index == 3;
    });
  }

  // 찜목록 / 리뷰 / 리뷰 외곽 버튼
  ButtonStyle _buttonStyle(bool isSelected) {
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blue : null,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  // 찜목록 / 리뷰 / 리뷰 내부 버튼 -> 글자 크기 고정하기 위해
  Widget _buttonChild(String text, bool isSelected) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSelectedInfo() {
    int columnCount = 3;
    // 3-1) 찜목록 데이터
    if (isFavoriteSelected) {
      print("찜목록 데이터 출력");
      return Expanded(
        child: GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: 100,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: columnCount,
              child: ScaleAnimation(
                child: FadeInAnimation(
                    child: Container(
                  color: Colors.grey[300],
                  child: Center(child: Text("찜목록 데이터")),
                )),
              ),
            );
          },
        ),
      );
    }
    // 3-2) 플랜 데이터
    else if (isPlanSelected) {
      print("플랜 데이터 출력");
      return Expanded(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: List.generate(
            3, // 샘플 데이터 개수
            (index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: 상세 일정표 화면으로 이동
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index == 0
                                  ? "주말 애인이랑 데이트" // 첫 번째 플랜 데이터
                                  : index == 1
                                      ? "동네 친구랑 술약속" // 두 번째 플랜 데이터
                                      : "가족 여행", // 세 번째 플랜 데이터
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "2024.03.1${index + 4}", // 날짜 (임의의 값)
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    // 3-3) 리뷰 데이터
    else if (isReviewSelected) {
      print("리뷰 데이터 출력");
      return Expanded(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: List.generate(
            2, // 샘플 데이터 개수 : 2개로 고정함
            (index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: 상세 일정표 화면으로 이동
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index == 0 ? "크리스마스 데이트" : "새해 데이트",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "2023.12.2${index + 4}", // 날짜 (임의의 값)
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else
      return SizedBox();
  }
}
