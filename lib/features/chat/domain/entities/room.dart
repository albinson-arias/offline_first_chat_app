import 'package:dart_mappable/dart_mappable.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';

part 'room.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Room with RoomMappable {
  const Room({
    required this.createdAt,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageStatus,
    required this.lastSenderId,
    required this.lastMessageTimeSent,
    required this.unReadMessages,
  });

  final DateTime createdAt;
  final List<Profile> participants;
  final String lastMessage;
  final MessageStatus lastMessageStatus;
  final String lastSenderId;
  final DateTime lastMessageTimeSent;
  final int unReadMessages;
}
