// 마이 페이지
import 'package:flutter/material.dart';

// 이후 import로 더 추가할 예정
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장
import 'package:http/http.dart' as http; // API 사용
import 'dart:convert'; // API 호출 : 디코딩
import 'package:intl/intl.dart'; // yyyy.mm.dd형식을 yy.mm.dd형식으로

// 아직 사용 X
String? userAccessToken = "";
String? userRefreshToken = "";

// 플랜 불러오기 1
class PlanDetailsPage extends StatefulWidget {
  final List<dynamic> schedule; // 스케줄 데이터 리스트를 받는다

  PlanDetailsPage({Key? key, required this.schedule}) : super(key: key);

  @override
  _PlanDetailsPageState createState() => _PlanDetailsPageState();
}

// 플랜 불러오기 2
class _PlanDetailsPageState extends State<PlanDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 계획'),
      ),
      body: Column(
        children: <Widget>[
          // 지도를 표시할 임시 컨테이너
          Container(
            height: 200, // 지도의 높이 설정
            color: Colors.grey[300], // 임시 컨테이너의 배경색
            child: Center(
              child: Text('여기에 지도가 표시됩니다'), // 지도 위치 표시 임시 텍스트
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
                itemCount: widget.schedule.length,
                itemBuilder: (context, index) {
                  DateTime startDate =
                      DateTime.parse(widget.schedule[index]['start_date']);
                  String formattedDate =
                      DateFormat('yyyy-MM-dd, HH:mm').format(startDate);

                  return Card(
                    key: ValueKey(
                        widget.schedule[index]['id']), // 각 요소의 고유 key를 설정합니다.
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text('${index + 1}',
                            style: TextStyle(color: Colors.white)),
                      ),
                      title: Text(widget.schedule[index]['place'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("$formattedDate"),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.drag_handle), // 사용자 지정 드래그 핸들 아이콘
                      ),
                    ),
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1; // 새 인덱스 보정
                    }
                    final item = widget.schedule.removeAt(oldIndex);
                    widget.schedule.insert(newIndex, item);
                  });
                },
                buildDefaultDragHandles: false // 기본 드래그 핸들 비활성화
                ),
          ),
        ],
      ),
    );
  }
}

// 찜목록
class FavoritePlace {
  final int id; // 장소 Id
  final String name; // 장소 이름
  final String streetNameAddress; // 주소
  final String imageUrl; // 이미지 url
  final String classification; // 분류

  FavoritePlace({
    required this.id,
    required this.name,
    required this.streetNameAddress,
    required this.imageUrl,
    required this.classification,
  });

  factory FavoritePlace.fromJson(Map<String, dynamic> json) {
    return FavoritePlace(
      id: json['id'] as int? ?? 0, // 'id'가 null이면 0을 기본값으로 사용
      name: json['name'] as String? ??
          'Unknown', // 'name'이 null이면 'Unknown'을 기본값으로 사용
      streetNameAddress: json['street_name_address'] as String? ??
          'No address provided', // 주소가 null이면 기본 텍스트 제공
      imageUrl:
          json['image'] as String? ?? '', // 'image'가 null이면 빈 문자열을 기본값으로 사용
      classification: json['classification'] as String? ??
          'Unclassified', // 'classification'이 null이면 'Unclassified'를 기본값으로 사용
    );
  }
}

// 리뷰 목록
class ReviewPlace {
  final int id; // 리뷰 Id
  final String content; // 리뷰 내용
  final String? image; // 이미지 URL, null 가능
  final int score; // 리뷰 점수
  final String createdAt; // 작성 날짜
  final int place; // 장소 Id
  final String writer; // 작성자

  ReviewPlace({
    required this.id,
    required this.content,
    required this.image,
    required this.score,
    required this.createdAt,
    required this.place,
    required this.writer,
  });

  factory ReviewPlace.fromJson(Map<String, dynamic> json) {
    return ReviewPlace(
      id: json['id'] as int? ?? 0, // 'id'가 null이면 0을 기본값으로 사용
      content: json['content'] as String? ??
          'No content', // 'content'가 null이면 'No content'를 기본값으로 사용
      image: json['image'] as String?, // 'image'는 null 가능
      score: json['score'] as int? ?? 0, // 'score'가 null이면 0을 기본값으로 사용
      createdAt: json['created_at'] as String? ??
          'Unknown date', // 'created_at'이 null이면 'Unknown date'를 기본값으로 사용
      place: json['place'] as int? ?? 0, // 'place'가 null이면 0을 기본값으로 사용
      writer: json['writer'] as String? ??
          'Unknown writer', // 'writer'가 null이면 'Unknown writer'를 기본값으로 사용
    );
  }
}

// 마이 페이지 1
class MyPage extends StatefulWidget {
  String userName; // 이전 페이지에서 userName 받아와서 업로드
  MyPage(this.userName);

  @override
  MyPageState createState() => MyPageState();
}

// 마이 페이지 2
class MyPageState extends State<MyPage> {
  bool isFavoriteSelected = false;
  bool isPlanSelected = false;
  bool isReviewSelected = false;

  String userId = ""; // 사용자 ID 데이터
  String userName = ""; // 사용자 이름 정보
  final storage = FlutterSecureStorage(); // Local 내부 저장소 사용
  int viewMode = 1; // 찜목록 정렬 (1개씩, 2개씩, 3개씩)

  // User 정보
  List<FavoritePlace> userFavorite = []; // 1. 찜목록 정보
  List<Map<String, dynamic>> userPlans = []; // 2. 플랜 정보
  List<ReviewPlace> userReviews = []; // 3. 리뷰 정보
  Map<int, String> placeNamesCache = {}; // 3.1 placeId -> placeName

  @override
  void initState() {
    super.initState();

    userName = widget.userName;
    _loadUserId(); // 유저 모델 데이터 가져오기
  }

  // API 1. 사용자 찜목록 보기
  Future<List<FavoritePlace>> fetchUserLikePlace() async {
    List<FavoritePlace> favorites = [];
    String? userId = await storage.read(key: "login_id");
    String? userAccessToken = await storage.read(key: "login_access_token");

    final url =
        Uri.parse('http://43.203.61.149/user/like/$userId'); // API 엔드포인트
    final response = await http.get(
      url,
      // 헤더에 Authorization 추가해서 access Token값 넣기
      headers: {
        'Authorization': 'Bearer $userAccessToken',
        "Content-Type": "application/json"
      },
    );

    // API 정상 응답
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes)); // UTF-8 인코딩 명시
      // 1. 찜목록 데이터 있을 때
      if (data['results'] != null && data['results'].isNotEmpty) {
        favorites = (data['results'] as List)
            .map((item) => FavoritePlace.fromJson(item))
            .toList();
        print(data['results']);
        print("찜목록 데이터 불러오기 성공");
      }
      // 2. 찜목록 데이터 없을 때
      else if (data['count'] == 0) {
        return [];
      }
    }
    // API 호출 실패
    else {
      print("API 호출 실패: ${response.statusCode}");
      return [];
    }
    return favorites; // FavoritePlace 리스트 반환
  }

  // API 2. User 모델 데이터 가져오기 API
  void _loadUserId() async {
    String? storedUserId = await storage.read(key: 'login_id');
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      // 1. 찜목록 데이터 가져오기
      fetchUserLikePlace().then((fetchFavorite) {
        setState(() {
          userFavorite = fetchFavorite;
        });
      }).catchError((error) {
        print(error);
      });

      // 2. 플랜 데이터 가져오기
      fetchPlansForUser().then((plans) {
        setState(() {
          userPlans = plans;
        });
      }).catchError((error) {
        print(error);
      });

      // 3. 리뷰 데이터 가져오기
      fetchUserReviewPlace().then((reviews) {
        setState(() {
          userReviews = reviews;
        });
      }).catchError((error) {
        print(error);
      });
    }
  }

  // API 3. 플랜 정보 가져오기 API
  Future<List<Map<String, dynamic>>> fetchPlansForUser() async {
    final response =
        await http.get(Uri.parse('http://43.203.61.149/plan/plan/'));

    // 호출 성공 시
    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseData is Map<String, dynamic>) {
        List<dynamic> plans = responseData['results'];
        List<Map<String, dynamic>> tempUserPlans = [];
        for (var plan in plans) {
          if (plan['user'].toString() == userId) {
            tempUserPlans.add(plan);
          }
        }
        return tempUserPlans;
      } else {
        throw Exception('The expected structure of the response is not found.');
      }
    } else {
      throw Exception('Failed to load plans');
    }
  }

  // API 4. 사용자 리뷰 목록 보기
  Future<List<ReviewPlace>> fetchUserReviewPlace() async {
    List<ReviewPlace> reviews = [];
    String? userId = await storage.read(key: "login_id");
    String? userAccessToken = await storage.read(key: "login_access_token");

    final url = Uri.parse(
        'http://43.203.61.149/user/list/$userId/reviews'); // API 엔드포인트
    final response = await http.get(
      url,
      // 헤더에 Authorization 추가해서 access Token값 넣기
      headers: {
        'Authorization': 'Bearer $userAccessToken',
        "Content-Type": "application/json"
      },
    );

    // API 정상 응답
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes)); // UTF-8 인코딩 명시
      // 1. 찜목록 데이터 있을 때
      if (data['results'] != null && data['results'].isNotEmpty) {
        reviews = (data['results'] as List)
            .map((item) => ReviewPlace.fromJson(item))
            .toList();
        print(data['results']);
        print("찜목록 데이터 불러오기 성공");
      }
      // 2. 찜목록 데이터 없을 때
      else if (data['count'] == 0) {
        return [];
      }
    }
    // API 호출 실패
    else {
      print("API 호출 실패: ${response.statusCode}");
      return [];
    }
    return reviews; // FavoritePlace 리스트 반환
  }

  // API 5. placeId -> placeName
  Future<String> fetchPlaceName(int placeId) async {
    if (placeNamesCache.containsKey(placeId)) {
      return placeNamesCache[placeId]!;
    }

    // 실제 API 호출
    final response = await http
        .get(Uri.parse('http://43.203.61.149/place/place/${placeId}'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      final placeName = jsonResponse['name'];
      placeNamesCache[placeId] = placeName;
      return placeName;
    } else {
      throw Exception('Failed to load place name');
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      isFavoriteSelected = index == 1;
      isPlanSelected = index == 2;
      isReviewSelected = index == 3;
    });
  }

  // 버튼
  ButtonStyle _buttonStyle(bool isSelected) {
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blue : null,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  // 버튼
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
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
              readOnly: true,
              initialValue: userName ?? "사용자 이름", // 전역 변수 사용
              textAlign: TextAlign.center,
            ),
          ),
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
          Expanded(
            child: _buildSelectedInfo(),
          ),
        ],
      ),
    );
  }

  // 데이터 정보 불러오기
  Widget _buildSelectedInfo() {
    if (isFavoriteSelected) {
      return _buildFavoriteList();
    } else if (isPlanSelected) {
      return _buildPlanList();
    } else if (isReviewSelected) {
      return _buildReviewList();
    } else {
      return SizedBox();
    }
  }

  // 찜목록 - 정렬 아이콘
  Icon get viewModeIcon {
    if (viewMode == 1) {
      return Icon(Icons.filter_1); // Icon for 2 items per row
    } else if (viewMode == 2) {
      return Icon(Icons.filter_2); // Icon for 1 item per row
    } else {
      return Icon(Icons.filter_3); // Icon for 3 items per row
    }
  }

  // 찜목록 - 정렬 아이콘 순환
  void cycleViewMode() {
    setState(() {
      viewMode = viewMode % 3 + 1;
    });
  }

  // 찜목록 - 정렬 버튼
  Widget _buildViewModeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.view_comfy),
          onPressed: () {
            setState(() {
              viewMode = 3;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.view_day),
          onPressed: () {
            setState(() {
              viewMode = 2;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.view_list),
          onPressed: () {
            setState(() {
              viewMode = 1;
            });
          },
        ),
      ],
    );
  }

  // 리스트 1 : 찜목록 UI
  Widget _buildFavoriteList() {
    // 정렬 순환 버튼 (1개씩, 2개씩, 3개씩 보여주기)
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: viewModeIcon,
              onPressed: cycleViewMode,
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<FavoritePlace>>(
            future: fetchUserLikePlace(), // 데이터를 불러오는 Future
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text(
                    "Error: ${snapshot.error?.toString() ?? 'Unknown error'}");
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: viewMode, // 열의 수는 viewMode 상태에 따라 결정
                    childAspectRatio: viewMode == 1
                        ? 2 / 1.5
                        : (viewMode == 2 ? 1 / 1.2 : 1 / 1.3),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var favorite = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        // Uncomment the following line to navigate to the details page
                        /*
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceDetailsPage(placeId: favorite.id),
                        ),
                      );
                      */
                      },
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // 카드 모서리를 둥글게 만듭니다.
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(
                                      15.0)), // 이미지 위쪽 모서리를 둥글게 만듭니다.
                              child: Image.network(
                                favorite.imageUrl.isEmpty
                                    ? "https://via.placeholder.com/150"
                                    : favorite.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: viewMode == 1
                                    ? 150
                                    : (viewMode == 2
                                        ? 120
                                        : 80), // 이미지 높이를 viewMode에 따라 조정
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favorite.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: viewMode == 1
                                            ? 18
                                            : (viewMode == 2 ? 14 : 10)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  // if (viewMode == 1 || viewMode == 2)
                                  Text(
                                    favorite
                                        .classification, // classification 추가
                                    style: TextStyle(
                                      fontSize: viewMode == 1
                                          ? 15
                                          : (viewMode == 2 ? 12 : 10),
                                      color: Colors.grey[500],
                                    ),

                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  if (viewMode == 1) // 1줄에 1개씩 보여질 때만 주소 보이도록
                                    Text(
                                      favorite.streetNameAddress,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600]),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Text("찜목록이 없습니다.");
              }
            },
          ),
        ),
      ],
    );
  }

  // 리스트 2 : 플랜
  Widget _buildPlanList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: userPlans.length,
            itemBuilder: (context, index) {
              // 일정 시작일을 표시하기 위한 로직
              String formattedDate = "미정"; // 기본값 설정
              if (userPlans[index]['schedule'].isNotEmpty) {
                DateTime startDate = DateTime.parse(
                    userPlans[index]['schedule'][0]['start_date']);
                formattedDate = DateFormat('yy.MM.dd').format(startDate);
              }

              return Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading:
                      Icon(Icons.map, color: Theme.of(context).primaryColor),
                  title: Text(userPlans[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("여행 시작일 : $formattedDate"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanDetailsPage(
                            schedule: userPlans[index]['schedule']),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: _showAddPlanDialog, // 이후에 UI 수정
            child: Text('새 플랜 작성'),
          ),
        ),
      ],
    );
  }

  // 리스트 3 : 리뷰
  Widget _buildReviewList() {
    return FutureBuilder<List<ReviewPlace>>(
      future: fetchUserReviewPlace(), // 데이터를 불러오는 Future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(
              "Error: ${snapshot.error?.toString() ?? 'Unknown error'}");
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '내가 쓴 총 리뷰 ${snapshot.data!.length}개',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var review = snapshot.data![index];
                    return FutureBuilder<String>(
                      future: fetchPlaceName(review.place),
                      builder: (context, placeSnapshot) {
                        if (placeSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        } else if (placeSnapshot.hasError) {
                          return Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Error loading place name"),
                            ),
                          );
                        } else {
                          return Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // 장소 상세 페이지로 이동하는 로직
                                      /*
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaceDetailsPage(placeId: review.place),
                                        ),
                                      );
                                      */
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          placeSnapshot.data!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _buildStarRating(review.score),
                                      SizedBox(width: 8),
                                      Text(
                                        _formatDate(review.createdAt),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    review.content,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Text("리뷰가 없습니다.");
        }
      },
    );
  }

  Widget _buildStarRating(int score) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < score ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.year}/${parsedDate.month}/${parsedDate.day}';
  }

  // 다이얼로그 표시 및 새 플랜 이름 입력 처리
  void _showAddPlanDialog() {
    TextEditingController _planNameController = TextEditingController();

    // 이후에 UI 수정
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("새 플랜 이름 입력"),
          content: TextField(
            controller: _planNameController,
            decoration: InputDecoration(hintText: "플랜 이름을 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('저장'),
              onPressed: () {
                _createPlan(_planNameController.text).then((_) {
                  Navigator.of(context).pop();
                  // 플랜 목록 갱신
                  fetchPlansForUser().then((plans) {
                    setState(() {
                      userPlans = plans;
                    });
                  }).catchError((error) {
                    print(error);
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  // API 호출하여 서버에 새 플랜 데이터 전송
  Future<void> _createPlan(String planName) async {
    final response = await http.post(
      Uri.parse('http://43.203.61.149/plan/plan/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": planName,
        "user": userId,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 데이터가 생성되면 UI 업데이트 또는 알림
      print('Plan created successfully.');
    } else {
      // 실패 처리
      print('Failed to create plan. Error: ${response.body}');
    }
  }
}
