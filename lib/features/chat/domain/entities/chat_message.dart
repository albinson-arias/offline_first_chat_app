import 'package:dart_mappable/dart_mappable.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';

part 'chat_message.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class ChatMessage with ChatMessageMappable {
  const ChatMessage({
    required this.id,
    required this.createdAt,
    required this.profile,
    required this.content,
    required this.status,
  });

  final String id;
  final DateTime createdAt;
  final Profile profile;
  final String content;
  final MessageStatus status;
}
