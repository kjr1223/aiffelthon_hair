import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageLoader {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> loadImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }
}
