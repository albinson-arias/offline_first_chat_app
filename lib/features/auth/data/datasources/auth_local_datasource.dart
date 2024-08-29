// ignore_for_file: one_member_abstracts

import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';

abstract interface class AuthLocalDatasource {
  Future<Profile> getCurrentUser();
}
