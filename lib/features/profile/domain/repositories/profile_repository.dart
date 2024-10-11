// ignore_for_file: one_member_abstracts

import 'package:cross_file/cross_file.dart';
import 'package:record_result/record_result.dart';

abstract interface class ProfileRepository {
  FutureResultVoid uploadProfilePicture(XFile imageFile);
  FutureResultVoid deleteProfilePicture();
  FutureResultVoid updateBio(String bio);
  FutureResultVoid updateFcmToken(String? fcmToken);
}
