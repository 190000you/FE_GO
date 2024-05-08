import 'package:flutter/material.dart';
import 'package:go_test_ver/postCard.dart';

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

  void initState() {
    super.initState();
    // 1번만 데이터 업로드
    if (!isLoading && weatherData == null) {
      fetchData();
    }
    // print("homeScreen.dart : Weather Data: $weatherData");
  }

  void fetchData() {
    setState(() {
      isLoading = true;
    });
    weatherData = getLocation().whenComplete(() => setState(() {
          isLoading = false;
        }));
  }

  // API 1. 현재 위치 + 행정 구역명 + 날씨 정보
  Future<Map<String, dynamic>> getLocation() async {
    Map<String, dynamic> result = {};
    try {
      // 1. 현재 위치 받기 (위도 + 경도)
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String lat = position.latitude.toString(); // 위도
      String lon = position.longitude.toString(); // 경도

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
        var data = jsonDecode(response.body); // string to json
        print('data = $data'); // 전체 데이터 출력
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
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return PostCard(
                      weatherData: snapshot.data!,
                      number: index, // 새로고침 함수 전달
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
            }
            // While waiting for the future to complete, show a loading spinner.
            // 수정된 부분: 중앙에 배치하기 위해 Center를 사용
            // 유의할점 : 메인페이지를 클릭할 때마다 로딩해야함.
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
          }),
    );
  }
}
