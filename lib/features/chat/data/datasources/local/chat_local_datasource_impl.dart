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

      final result = await _db.getAll(getContactsSQLQuery, [userId]);

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
  Future<Room?> getRoomWithParticipant(String id) async {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      final result = await _db.getAll(getRoomWithParticipantSQLQuery, [id]);

      final rooms = result.map(RoomMapper.fromMap).toList(growable: false);

      if (rooms.isEmpty) return null;

      return rooms.first;
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

  @override
  Future<Room> startConversation(Profile profile) async {
    try {
      final userId = _auth.currentUser?.id;

      if (userId == null) {
        throw const ServerException(
          message: 'User is not logged in',
          statusCode: '504',
        );
      }

      await _db.writeTransaction<void>(
        (tx) async {
          // Create new room
          final newRoomId = uuid.v1();
          await tx.execute(createRoomSQLQuery, [newRoomId]);

          // Add participants to room
          await tx.executeBatch(addRoomParticipantsSQLQuery, [
            [userId, newRoomId],
            [profile.id, newRoomId],
          ]);
        },
      );

      var room = (await getRoomWithParticipant(profile.id))!;

      if (room.participants.length > 1) return room;

      // If room only has 1 participants means it hasnt synced correctly
      // so keep trying until it has

      while (room.participants.length < 2) {
        final currentRoom = await getRoomWithParticipant(profile.id);
        if (currentRoom != null) {
          room = currentRoom;
        }
      }
      return room;
    } on ServerException {
      rethrow;
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
