import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aiffelthon_/imageLoader.dart';

class AnalysisScreen extends StatefulWidget {
  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_image != null)
            SizedBox(
              width: screenWidth,
              height: screenHeight * 0.6,
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
            )
          else
            Text('No image selected.'),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final loadedImage = await loadImage(); // 갤러리에서 이미지 불러오기
                if (loadedImage != null) {
                  setState(() {
                    _image = loadedImage;
                  });
                }
              },
              child: Text('Select Image'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  'Scalp Type Result:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '분석결과없음',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
