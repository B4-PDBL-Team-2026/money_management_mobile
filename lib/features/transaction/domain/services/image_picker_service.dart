import 'dart:io';

abstract class ImagePickerService {
  Future<File?> pickFromGallery();
}
