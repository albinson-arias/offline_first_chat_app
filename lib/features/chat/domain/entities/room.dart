import 'package:dart_mappable/dart_mappable.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/list_profile_hook.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';

part 'room.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase, hook: ListProfileHook())
class Room with RoomMappable {
  const Room({
    required this.createdAt,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageStatus,
    required this.lastSenderId,
    required this.lastMessageTimeSent,
    required this.unreadMessages,
  });

  final DateTime createdAt;
  @MappableField(hook: ListProfileHook())
  final List<Profile> participants;
  final String lastMessage;
  final MessageStatus lastMessageStatus;
  final String lastSenderId;
  final DateTime lastMessageTimeSent;
  final int unreadMessages;

  List<Profile> get otherParticipants {
    final myUserId = sl<GlobalStore>().userId;
    return participants
        .where(
          (element) => element.id != myUserId,
        )
        .toList();
  }

  bool get lastSenderIsMe {
    final myUserId = sl<GlobalStore>().userId;
    return lastSenderId == myUserId;
  }

  String get name {
    return otherParticipants.first.username;
  }

  String? get imageUrl {
    return otherParticipants.first.imageUrl;
  }
}
