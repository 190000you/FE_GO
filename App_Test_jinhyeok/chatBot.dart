import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart'; // 웹 브라우저로 이동
import 'package:webview_flutter/webview_flutter.dart'; // 앱 안에 웹 브라우저 띄우기

// 챗봇 URL
final Uri url = Uri.parse(
    'https://langchaindaegutour-9mqtnttwtajpztax689bw4.streamlit.app/');

// https://langchaindaegutour-9mqtnttwtajpztax689bw4.streamlit.app/

class ChatBotPage extends StatefulWidget {
  @override
  ChatBotPageState createState() => ChatBotPageState();
}

class ChatBotPageState extends State<ChatBotPage> {
  WebViewController? _webViewController; // webview_flutter 변수 선언

  void initState() {
    _webViewController = WebViewController() // webview_flutter 사용
      ..loadRequest(Uri.parse(
          'https://langchaindaegutour-9mqtnttwtajpztax689bw4.streamlit.app/'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example1')),
      body: WebViewWidget(controller: _webViewController!), // 컨트롤러 사용
    );
  }
}
