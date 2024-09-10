import 'package:dart_mappable/dart_mappable.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/list_profile_hook.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';

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
  @MappableField(hook: ListProfileHook())
  final Profile profile;
  final String content;
  final MessageStatus status;

  bool get isMine {
    final myUserId = sl<GlobalStore>().userId;
    return profile.id == myUserId;
  }
}
