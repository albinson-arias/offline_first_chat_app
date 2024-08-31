import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';

abstract interface class ChatRepository {
  Stream<List<Room>> getRooms();

  Stream<List<ChatMessage>> getMessagesForRoom(String id);

  Future<List<Profile>> getContacts();

  Future<List<Profile>> searchProfiles(String search);

  Future<void> sendMessage(String roomId, String content);
}
