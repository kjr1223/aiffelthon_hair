import 'dart:io';
import 'package:image_picker/image_picker.dart';

final ImagePicker _imagePicker = ImagePicker();

// 갤러리에서 이미지 선택
Future<File?> loadImage() async {
  final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    return File(pickedImage.path);
  }
  return null;
}
