// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'room.dart';

class RoomMapper extends ClassMapperBase<Room> {
  RoomMapper._();

  static RoomMapper? _instance;
  static RoomMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RoomMapper._());
      ProfileMapper.ensureInitialized();
      MessageStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Room';

  static String _$id(Room v) => v.id;
  static const Field<Room, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(Room v) => v.createdAt;
  static const Field<Room, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: 'created_at');
  static List<Profile> _$participants(Room v) => v.participants;
  static const Field<Room, List<Profile>> _f$participants =
      Field('participants', _$participants, hook: ListProfileHook());
  static String _$lastMessage(Room v) => v.lastMessage;
  static const Field<Room, String> _f$lastMessage =
      Field('lastMessage', _$lastMessage, key: 'last_message');
  static MessageStatus _$lastMessageStatus(Room v) => v.lastMessageStatus;
  static const Field<Room, MessageStatus> _f$lastMessageStatus = Field(
      'lastMessageStatus', _$lastMessageStatus,
      key: 'last_message_status');
  static String _$lastSenderId(Room v) => v.lastSenderId;
  static const Field<Room, String> _f$lastSenderId =
      Field('lastSenderId', _$lastSenderId, key: 'last_sender_id');
  static DateTime _$lastMessageTimeSent(Room v) => v.lastMessageTimeSent;
  static const Field<Room, DateTime> _f$lastMessageTimeSent = Field(
      'lastMessageTimeSent', _$lastMessageTimeSent,
      key: 'last_message_time_sent');
  static int _$unreadMessages(Room v) => v.unreadMessages;
  static const Field<Room, int> _f$unreadMessages =
      Field('unreadMessages', _$unreadMessages, key: 'unread_messages');

  @override
  final MappableFields<Room> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #participants: _f$participants,
    #lastMessage: _f$lastMessage,
    #lastMessageStatus: _f$lastMessageStatus,
    #lastSenderId: _f$lastSenderId,
    #lastMessageTimeSent: _f$lastMessageTimeSent,
    #unreadMessages: _f$unreadMessages,
  };

  @override
  final MappingHook hook = const ListProfileHook();
  static Room _instantiate(DecodingData data) {
    return Room(
        id: data.dec(_f$id),
        createdAt: data.dec(_f$createdAt),
        participants: data.dec(_f$participants),
        lastMessage: data.dec(_f$lastMessage),
        lastMessageStatus: data.dec(_f$lastMessageStatus),
        lastSenderId: data.dec(_f$lastSenderId),
        lastMessageTimeSent: data.dec(_f$lastMessageTimeSent),
        unreadMessages: data.dec(_f$unreadMessages));
  }

  @override
  final Function instantiate = _instantiate;

  static Room fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Room>(map);
  }

  static Room fromJson(String json) {
    return ensureInitialized().decodeJson<Room>(json);
  }
}

mixin RoomMappable {
  String toJson() {
    return RoomMapper.ensureInitialized().encodeJson<Room>(this as Room);
  }

  Map<String, dynamic> toMap() {
    return RoomMapper.ensureInitialized().encodeMap<Room>(this as Room);
  }

  RoomCopyWith<Room, Room, Room> get copyWith =>
      _RoomCopyWithImpl(this as Room, $identity, $identity);
  @override
  String toString() {
    return RoomMapper.ensureInitialized().stringifyValue(this as Room);
  }

  @override
  bool operator ==(Object other) {
    return RoomMapper.ensureInitialized().equalsValue(this as Room, other);
  }

  @override
  int get hashCode {
    return RoomMapper.ensureInitialized().hashValue(this as Room);
  }
}

extension RoomValueCopy<$R, $Out> on ObjectCopyWith<$R, Room, $Out> {
  RoomCopyWith<$R, Room, $Out> get $asRoom =>
      $base.as((v, t, t2) => _RoomCopyWithImpl(v, t, t2));
}

abstract class RoomCopyWith<$R, $In extends Room, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Profile, ProfileCopyWith<$R, Profile, Profile>>
      get participants;
  $R call(
      {String? id,
      DateTime? createdAt,
      List<Profile>? participants,
      String? lastMessage,
      MessageStatus? lastMessageStatus,
      String? lastSenderId,
      DateTime? lastMessageTimeSent,
      int? unreadMessages});
  RoomCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RoomCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Room, $Out>
    implements RoomCopyWith<$R, Room, $Out> {
  _RoomCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Room> $mapper = RoomMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Profile, ProfileCopyWith<$R, Profile, Profile>>
      get participants => ListCopyWith($value.participants,
          (v, t) => v.copyWith.$chain(t), (v) => call(participants: v));
  @override
  $R call(
          {String? id,
          DateTime? createdAt,
          List<Profile>? participants,
          String? lastMessage,
          MessageStatus? lastMessageStatus,
          String? lastSenderId,
          DateTime? lastMessageTimeSent,
          int? unreadMessages}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (createdAt != null) #createdAt: createdAt,
        if (participants != null) #participants: participants,
        if (lastMessage != null) #lastMessage: lastMessage,
        if (lastMessageStatus != null) #lastMessageStatus: lastMessageStatus,
        if (lastSenderId != null) #lastSenderId: lastSenderId,
        if (lastMessageTimeSent != null)
          #lastMessageTimeSent: lastMessageTimeSent,
        if (unreadMessages != null) #unreadMessages: unreadMessages
      }));
  @override
  Room $make(CopyWithData data) => Room(
      id: data.get(#id, or: $value.id),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      participants: data.get(#participants, or: $value.participants),
      lastMessage: data.get(#lastMessage, or: $value.lastMessage),
      lastMessageStatus:
          data.get(#lastMessageStatus, or: $value.lastMessageStatus),
      lastSenderId: data.get(#lastSenderId, or: $value.lastSenderId),
      lastMessageTimeSent:
          data.get(#lastMessageTimeSent, or: $value.lastMessageTimeSent),
      unreadMessages: data.get(#unreadMessages, or: $value.unreadMessages));

  @override
  RoomCopyWith<$R2, Room, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _RoomCopyWithImpl($value, $cast, t);
}
