import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'history_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload and Result',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  String _result = ''; // Initialize _result
  int _selectedIndex = 0;
  // VoidCallback? getImage;
  // late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    void _getImage() async {
      final imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    }

    _widgetOptions = [
      ImageUploadContent(
        getImage: _getImage,
        image: _image,
        result: _result,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Search',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      HistoryScreen(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'History',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      Column(
        children: [
          Text(
            'My Info',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          Text('Result: $_result'),
        ],
      ),
    ];
  }

  late List<Widget> _widgetOptions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload and Result'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class ImageUploadContent extends StatefulWidget {
  final VoidCallback getImage;
  final File? image;
  final String result;

  ImageUploadContent({
    required this.getImage,
    required this.image,
    required this.result,
  });

  @override
  State<ImageUploadContent> createState() => _ImageUploadContentState();
}

class _ImageUploadContentState extends State<ImageUploadContent> {
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
              onPressed: widget.getImage,
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
                  widget.result,
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
