// 내부 import
import 'package:flutter/material.dart';
import 'package:go_test_ver/postCard.dart';
import 'package:go_test_ver/recommand.dart';

// 외부 import
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Token 저장
import 'package:geolocator/geolocator.dart'; // 실시간 위치 정보
import 'package:http/http.dart' as http; // API 사용
import 'dart:convert'; // API 호출 : 디코딩

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final storage = FlutterSecureStorage();
  Future<Map<String, dynamic>>? weatherData;
  bool isLoading = false;
  String lat = "";
  String lon = "";

  // API 1. 매번 달라지는 추천 장소 5개
  Future<List<Map<String, dynamic>>> fetchdailyrecommand() async {
    String? userAccessToken = await storage.read(key: "login_access_token");

    final url = Uri.parse('http://43.203.61.149/plan/dailyrecommand');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $userAccessToken',
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> results = data['results'];

      List<Map<String, dynamic>> places = results.map((place) {
        return place as Map<String, dynamic>;
      }).toList();

      return places;
    } else {
      final snackBar = SnackBar(content: Text("정보 불러오기에 실패하였습니다."));
      return [];
    }
  }

  void initState() {
    super.initState();
    // 1번만 데이터 업로드
    if (!isLoading && weatherData == null) {
      fetchData();
    }
  }

  void fetchData() {
    setState(() {
      isLoading = true;
    });
    weatherData = getLocation().whenComplete(() => setState(() {
          isLoading = false;
        }));
  }

  // API 2. 현재 위치 + 행정 구역명 + 날씨 정보
  Future<Map<String, dynamic>> getLocation() async {
    Map<String, dynamic> result = {};
    try {
      // 1. 현재 위치 받기 (위도 + 경도)
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude.toString(); // 위도
      lon = position.longitude.toString(); // 경도
      print(lat + lon);
      // storage에 저장 (1) - lat
      await storage.write(
        key: 'lat',
        value: lat, // userId
      );

      // storage에 저장 (1) - lon
      await storage.write(
        key: 'lon',
        value: lon, // userId
      );

      // 2. 위도 경도 -> 행정 구역으로 바꿈 // 오류 발생

      // 3. 날씨 정보 얻기
      String openweatherkey = "0e047ef5cce50504edc52d08b01c1933";
      var str =
          'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openweatherkey&units=metric';
      // print("날씨 정보 : " + str);

      final response = await http.get(
        Uri.parse(str),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // string to json
        // print('data = $data'); // 전체 데이터 출력
        result['conditionId'] = data['weather'][0]['id'];
        result['temperature'] = data['main']['temp'].toString();
        result['temperature_min'] = data['main']['temp_min'].toString();
        result['temperature_max'] = data['main']['temp_max'].toString();
        result['humidity'] = data['main']['humidity'].toString();
      } else {
        print('response status code = ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching weather: $e");
    } finally {
      setState(() {
        isLoading = false; // 로딩 종료
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchdailyrecommand(),
                builder: (context, placesSnapshot) {
                  if (placesSnapshot.connectionState == ConnectionState.done) {
                    if (placesSnapshot.hasData &&
                        placesSnapshot.data!.length >= 5) {
                      return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return PostCard(
                            lat: lat,
                            lon: lon,
                            // place1: placesSnapshot.data![0],
                            // place2: placesSnapshot.data![1],
                            // place3: placesSnapshot.data![2],
                            // place4: placesSnapshot.data![3],
                            // place5: placesSnapshot.data![4],
                            weatherData: snapshot.data!,
                            number: index,
                          );
                        },
                      );
                    } else if (placesSnapshot.hasError) {
                      return Text('Error: ${placesSnapshot.error}');
                    } else {
                      return Text('Not enough data');
                    }
                  } else {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF967BB6)), // 파스텔 진보라색
                          backgroundColor: Color(0xFFEDE7F6),
                          strokeWidth: 8.0,
                        ),
                      ),
                    );
                  }
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF967BB6)), // 파스텔 진보라색
                    backgroundColor: Color(0xFFEDE7F6),
                    strokeWidth: 8.0,
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF967BB6)), // 파스텔 진보라색
                  backgroundColor: Color(0xFFEDE7F6),
                  strokeWidth: 8.0,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
