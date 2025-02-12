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
    required this.id,
    required this.createdAt,
    required this.participants,
    required this.unreadMessages,
    this.lastMessage,
    this.lastMessageStatus,
    this.lastSenderId,
    this.lastMessageTimeSent,
  });

  final String id;
  final DateTime createdAt;
  @MappableField(hook: ListProfileHook())
  final List<Profile> participants;
  final String? lastMessage;
  final MessageStatus? lastMessageStatus;
  final String? lastSenderId;
  final DateTime? lastMessageTimeSent;
  final int unreadMessages;

  List<Profile> get otherParticipants {
    final myUserId = sl<GlobalStore>().userId;
    return participants
        .where(
          (element) => element.id != myUserId,
        )
        .toList();
  }

  Profile get otherParticipant {
    return otherParticipants.first;
  }

  bool get lastSenderIsMe {
    final myUserId = sl<GlobalStore>().userId;
    return lastSenderId == myUserId;
  }

  String get name {
    if (otherParticipants.isEmpty) return '';
    return otherParticipant.username;
  }

  String? get imageUrl {
    if (otherParticipants.isEmpty) return null;
    return otherParticipant.imageUrl;
  }
}
