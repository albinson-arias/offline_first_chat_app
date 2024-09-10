// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_message.dart';

class ChatMessageMapper extends ClassMapperBase<ChatMessage> {
  ChatMessageMapper._();

  static ChatMessageMapper? _instance;
  static ChatMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatMessageMapper._());
      ProfileMapper.ensureInitialized();
      MessageStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatMessage';

  static String _$id(ChatMessage v) => v.id;
  static const Field<ChatMessage, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(ChatMessage v) => v.createdAt;
  static const Field<ChatMessage, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: 'created_at');
  static Profile _$profile(ChatMessage v) => v.profile;
  static const Field<ChatMessage, Profile> _f$profile =
      Field('profile', _$profile, hook: ListProfileHook());
  static String _$content(ChatMessage v) => v.content;
  static const Field<ChatMessage, String> _f$content =
      Field('content', _$content);
  static MessageStatus _$status(ChatMessage v) => v.status;
  static const Field<ChatMessage, MessageStatus> _f$status =
      Field('status', _$status);

  @override
  final MappableFields<ChatMessage> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #profile: _f$profile,
    #content: _f$content,
    #status: _f$status,
  };

  static ChatMessage _instantiate(DecodingData data) {
    return ChatMessage(
        id: data.dec(_f$id),
        createdAt: data.dec(_f$createdAt),
        profile: data.dec(_f$profile),
        content: data.dec(_f$content),
        status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatMessage>(map);
  }

  static ChatMessage fromJson(String json) {
    return ensureInitialized().decodeJson<ChatMessage>(json);
  }
}

mixin ChatMessageMappable {
  String toJson() {
    return ChatMessageMapper.ensureInitialized()
        .encodeJson<ChatMessage>(this as ChatMessage);
  }

  Map<String, dynamic> toMap() {
    return ChatMessageMapper.ensureInitialized()
        .encodeMap<ChatMessage>(this as ChatMessage);
  }

  ChatMessageCopyWith<ChatMessage, ChatMessage, ChatMessage> get copyWith =>
      _ChatMessageCopyWithImpl(this as ChatMessage, $identity, $identity);
  @override
  String toString() {
    return ChatMessageMapper.ensureInitialized()
        .stringifyValue(this as ChatMessage);
  }

  @override
  bool operator ==(Object other) {
    return ChatMessageMapper.ensureInitialized()
        .equalsValue(this as ChatMessage, other);
  }

  @override
  int get hashCode {
    return ChatMessageMapper.ensureInitialized().hashValue(this as ChatMessage);
  }
}

extension ChatMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatMessage, $Out> {
  ChatMessageCopyWith<$R, ChatMessage, $Out> get $asChatMessage =>
      $base.as((v, t, t2) => _ChatMessageCopyWithImpl(v, t, t2));
}

abstract class ChatMessageCopyWith<$R, $In extends ChatMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ProfileCopyWith<$R, Profile, Profile> get profile;
  $R call(
      {String? id,
      DateTime? createdAt,
      Profile? profile,
      String? content,
      MessageStatus? status});
  ChatMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatMessage, $Out>
    implements ChatMessageCopyWith<$R, ChatMessage, $Out> {
  _ChatMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatMessage> $mapper =
      ChatMessageMapper.ensureInitialized();
  @override
  ProfileCopyWith<$R, Profile, Profile> get profile =>
      $value.profile.copyWith.$chain((v) => call(profile: v));
  @override
  $R call(
          {String? id,
          DateTime? createdAt,
          Profile? profile,
          String? content,
          MessageStatus? status}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (createdAt != null) #createdAt: createdAt,
        if (profile != null) #profile: profile,
        if (content != null) #content: content,
        if (status != null) #status: status
      }));
  @override
  ChatMessage $make(CopyWithData data) => ChatMessage(
      id: data.get(#id, or: $value.id),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      profile: data.get(#profile, or: $value.profile),
      content: data.get(#content, or: $value.content),
      status: data.get(#status, or: $value.status));

  @override
  ChatMessageCopyWith<$R2, ChatMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ChatMessageCopyWithImpl($value, $cast, t);
}
