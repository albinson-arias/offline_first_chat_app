// ignore_for_file: one_member_abstracts

import 'package:image_picker/image_picker.dart';
import 'package:record_result/record_result.dart';

abstract interface class ImageUploader {
  FutureResult<String> uploadImage(XFile image);
}
