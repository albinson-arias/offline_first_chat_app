import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';

abstract interface class ChatRemoteDatasource {
  Future<List<Profile>> searchProfiles(String search);

  Future<void> sendMessage(ChatMessage message);
}
