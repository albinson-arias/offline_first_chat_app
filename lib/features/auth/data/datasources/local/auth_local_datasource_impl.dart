import 'package:flutter/foundation.dart';
import 'package:offline_first_chat_app/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/src/core/errors/exceptions.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  AuthLocalDatasourceImpl({
    required PowerSyncDatabase db,
    required GoTrueClient auth,
  })  : _db = db,
        _auth = auth;

  final PowerSyncDatabase _db;
  final GoTrueClient _auth;

  @override
  Future<Profile> getCurrentUser() async {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      const sqlQuery = 'SELECT * FROM profiles WHERE id = ? LIMIT 1';

      final result = await _db.get(sqlQuery, [userId]);

      final profile = ProfileMapper.fromMap(result);

      return profile;
    } on ServerException {
      rethrow;
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Stream<Profile> getCurrentUserStream() {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      const sqlQuery = 'SELECT * FROM profiles WHERE id = ? LIMIT 1';

      final result = _db.watch(sqlQuery, parameters: [userId]);

      return result.map(
        (event) {
          return event.map(ProfileMapper.fromMap).toList(growable: false).first;
        },
      );
    } on ServerException {
      rethrow;
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
