import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';

import '../../../../test_utils/common_mocks.dart';

void main() {
  late MockGlobalStore mockGlobalStore;

  setUp(() {
    mockGlobalStore = MockGlobalStore();
    // Register mock GlobalStore to the service locator
    sl.registerSingleton<GlobalStore>(mockGlobalStore);
  });

  tearDown(sl.reset);

  group('Room Tests', () {
    final profile1 = Profile(
      id: 'user1',
      username: 'John',
      imageUrl: 'image1.png',
      createdAt: DateTime(200, 06, 11),
      bio: '',
    );
    final profile2 = Profile(
      id: 'user2',
      username: 'Jane',
      imageUrl: 'image2.png',
      createdAt: DateTime(200, 06, 11),
      bio: '',
    );
    test('can instantiate a Room object', () {
      final room = Room(
        id: 'room1',
        createdAt: DateTime.now(),
        participants: [profile1, profile2],
        unreadMessages: 3,
        lastMessage: 'Hello',
        lastMessageStatus: MessageStatus.read,
        lastSenderId: 'user1',
        lastMessageTimeSent: DateTime.now(),
      );

      expect(room.id, 'room1');
      expect(room.participants.length, 2);
      expect(room.unreadMessages, 3);
      expect(room.lastMessage, 'Hello');
    });

    test('otherParticipants returns participants excluding current user', () {
      when(() => mockGlobalStore.userId).thenReturn('user1');

      final room = Room(
        id: 'room1',
        createdAt: DateTime.now(),
        participants: [profile1, profile2],
        unreadMessages: 0,
      );

      expect(room.otherParticipants.length, 1);
      expect(room.otherParticipants.first.id, 'user2');
    });

    test(
        'otherParticipant returns the first participant from otherParticipants',
        () {
      when(() => mockGlobalStore.userId).thenReturn('user1');

      final room = Room(
        id: 'room1',
        createdAt: DateTime.now(),
        participants: [profile1, profile2],
        unreadMessages: 0,
      );

      expect(room.otherParticipant.id, 'user2');
    });

    test(
        'lastSenderIsMe returns true if last message was'
        ' sent by the current user', () {
      when(() => mockGlobalStore.userId).thenReturn('user1');

      final room = Room(
        id: 'room1',
        createdAt: DateTime.now(),
        participants: [],
        unreadMessages: 0,
        lastSenderId: 'user1',
      );

      expect(room.lastSenderIsMe, isTrue);
    });

    test(
        'lastSenderIsMe returns false if last message'
        ' was not sent by the current user', () {
      when(() => mockGlobalStore.userId).thenReturn('user1');

      final room = Room(
        id: 'room1',
        createdAt: DateTime.now(),
        participants: [],
        unreadMessages: 0,
        lastSenderId: 'user2',
      );

      expect(room.lastSenderIsMe, isFalse);
    });

    test('name returns the username of the first otherParticipant', () {
      when(() => mockGlobalStore.userId).thenReturn('user1');

      final room = Room(
        id: 'room1',
        createdAt: DateTime.now(),
        participants: [profile1, profile2],
        unreadMessages: 0,
      );

      expect(room.name, 'Jane');
    });

    test('imageUrl returns the imageUrl of the first otherParticipant', () {
      when(() => mockGlobalStore.userId).thenReturn('user1');

      final room = Room(
        id: 'room1',
        createdAt: DateTime.now(),
        participants: [profile1, profile2],
        unreadMessages: 0,
      );

      expect(room.imageUrl, 'image2.png');
    });

    test('serializes and deserializes Room correctly', () {
      final room = Room(
        id: 'room1',
        createdAt: DateTime(2024, 10),
        participants: [profile1, profile2],
        unreadMessages: 3,
        lastMessage: 'Hello',
        lastMessageStatus: MessageStatus.read,
        lastSenderId: 'user1',
        lastMessageTimeSent: DateTime(2024, 10, 1, 10, 30),
      );

      // Serialize to JSON
      final json = room.toMap();
      expect(json['id'], 'room1');
      expect((json['participants'] as List).length, 2);
      expect(json['unread_messages'], 3);
      expect(json['last_message'], 'Hello');

      // Deserialize from JSON
      final deserializedRoom = RoomMapper.fromMap(json);
      expect(deserializedRoom.id, 'room1');
      expect(deserializedRoom.participants.length, 2);
      expect(deserializedRoom.unreadMessages, 3);
      expect(deserializedRoom.lastMessage, 'Hello');
    });
  });
}
