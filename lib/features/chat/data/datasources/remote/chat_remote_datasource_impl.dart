import 'package:flutter/foundation.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/src/core/errors/exceptions.dart';
import 'package:offline_first_chat_app/src/database/database_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  ChatRemoteDatasourceImpl({
    required GoTrueClient auth,
    required PostgrestClient database,
  })  : _auth = auth,
        _database = database;

  final GoTrueClient _auth;
  final PostgrestClient _database;

  @override
  Future<List<Profile>> searchProfiles(String search) async {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      final result = await _database
          .from(DatabaseConstants.profilesTable)
          .select()
          .textSearch('username', search);

      return result.map(ProfileMapper.fromMap).toList();
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code ?? '505',
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    try {
      final updatedMessage =
          message.copyWith(status: MessageStatus.sent).toMap()
            ..update(
              'created_at',
              (value) => 'NOW()',
            );
      await _database
          .from(DatabaseConstants.messagesTable)
          .insert(updatedMessage);
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: e.code ?? '505',
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
