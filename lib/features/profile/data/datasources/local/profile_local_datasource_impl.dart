import 'package:flutter/foundation.dart';
import 'package:offline_first_chat_app/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:offline_first_chat_app/src/core/errors/exceptions.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_local_datasource_impl.queries.dart';

class ProfileLocalDatasourceImpl implements ProfileLocalDatasource {
  ProfileLocalDatasourceImpl({
    required PowerSyncDatabase db,
    required GoTrueClient auth,
  })  : _db = db,
        _auth = auth;

  final PowerSyncDatabase _db;
  final GoTrueClient _auth;

  @override
  Future<void> updateProfilePicture(String imageUrl) async {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      await _db.execute(updateProfilePicSQLQuery, [imageUrl, userId]);
    } on ServerException {
      rethrow;
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
