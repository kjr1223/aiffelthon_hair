import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> surveyData;

  ResultScreen({required this.surveyData});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    products = fetchProducts(widget.surveyData['scalpType']);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // ThemeProvider 상태 가져오기

    // 테마 정보에 따라 Text의 스타일을 설정합니다.
    TextStyle titleStyle = themeProvider.isDarkMode
        ? TextStyle(color: Colors.white)
        : TextStyle(color: Colors.black);
    Color scaffoldBackgroundColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("문진 결과 및 상품 추천"),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.blue,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("성별: ${widget.surveyData['gender']}", style: titleStyle),
                Text("나이: ${widget.surveyData['age']}", style: titleStyle),
                Text("두피 유형: ${widget.surveyData['scalpType']}",
                    style: titleStyle),
                Text("샴푸 사용 빈도: ${widget.surveyData['shampooFrequency']}",
                    style: titleStyle),
                Text("펌 주기: ${widget.surveyData['permFrequency']}",
                    style: titleStyle),
                Text("염색 주기(자가 염색 포함): ${widget.surveyData['dyeFrequency']}",
                    style: titleStyle),
                Text("현재 모발 상태: ${widget.surveyData['currentHairState']}",
                    style: titleStyle),
                Text(
                    "현재 사용하고 있는 두피모발용 제품: ${widget.surveyData['hairProducts'].join(', ')}",
                    style: titleStyle),
                Text(
                    "맞춤 두피케어 제품사용을 희망하시나요?: ${widget.surveyData['wantCustomCare'] == true ? '예' : '아니오'}",
                    style: titleStyle),
                Text(
                    "샴푸 구매시 중요시 고려하는 부분: ${widget.surveyData['shampooPriority']}",
                    style: titleStyle),
              ],
            ),
          ),
          FutureBuilder<List<Product>>(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('오류가 발생했습니다.'));
                }

                return Column(
                  children: snapshot.data!.map((product) {
                    return ListTile(
                      leading: Image.network(product.imageUrl),
                      title: Text(product.title),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WebViewScreen(url: product.link),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<Product>> fetchProducts(String? scalpType) async {
    final query = '$scalpType 샴푸';
    final url =
        'https://openapi.naver.com/v1/search/shop.json?query=$query&display=10';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-Naver-Client-Id': 'xu4DalJtDyUjQPs5YZXe',
        'X-Naver-Client-Secret': '2_5rhWe2z2',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Product> products = (data['items'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class Product {
  final String title;
  final String link;
  final String imageUrl;

  Product({required this.title, required this.link, required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    String cleanTitle = _removeHtmlTags(json['title']);
    return Product(
      title: cleanTitle,
      link: json['link'],
      imageUrl: json['image'],
    );
  }

  static String _removeHtmlTags(String htmlText) {
    final RegExp regExp = RegExp(r'<[^>]*>', multiLine: true);
    return htmlText.replaceAll(regExp, '');
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("웹뷰"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
