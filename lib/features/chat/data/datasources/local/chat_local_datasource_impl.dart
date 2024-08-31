import 'package:flutter/foundation.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/local/chat_local_datasource.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/src/core/errors/exceptions.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'chat_local_datasource_impl.queries.dart';

class ChatLocalDatasourceImpl implements ChatLocalDatasource {
  ChatLocalDatasourceImpl({
    required PowerSyncDatabase db,
    required GoTrueClient auth,
  })  : _db = db,
        _auth = auth;

  final PowerSyncDatabase _db;
  final GoTrueClient _auth;

  @override
  Future<List<Profile>> getContacts() async {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      final result = await _db.getAll(getContactsSQLQuery);

      final profiles =
          result.map(ProfileMapper.fromMap).toList(growable: false);

      return profiles;
    } on ServerException {
      rethrow;
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Stream<List<ChatMessage>> getMessagesForRoom(String id) {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      return _db.watch(getMessagesFromRoomSQLQuery, parameters: [id]).map(
        (event) {
          return event.map(ChatMessageMapper.fromMap).toList(growable: false);
        },
      );
    } on ServerException {
      rethrow;
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Stream<List<Room>> getRooms() {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      return _db.watch(getAllRoomsSQLQuery).map(
        (event) {
          return event.map(RoomMapper.fromMap).toList(growable: false);
        },
      );
    } on ServerException {
      rethrow;
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> sendMessage(String roomId, String content) async {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      await _db.execute(sendMessageSQLQuery, [roomId, userId, content]);
    } on ServerException {
      rethrow;
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
