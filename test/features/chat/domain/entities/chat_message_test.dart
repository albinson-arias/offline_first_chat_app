import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';

import '../../../../test_utils/common_mocks.dart';

void main() {
  late MockGlobalStore mockGlobalStore;

  setUp(() {
    mockGlobalStore = MockGlobalStore();
    // Inject the mockGlobalStore into the service locator
    sl.registerSingleton<GlobalStore>(mockGlobalStore);
  });

  tearDown(sl.reset);

  group('ChatMessage Tests', () {
    final profile = Profile(
      id: 'user1',
      username: 'John Doe',
      createdAt: DateTime(2002, 06, 11),
      bio: '',
    );

    final otherProfile = Profile(
      id: 'user2',
      username: 'Albinson Arias',
      createdAt: DateTime(2002, 06, 11),
      bio: '',
    );
    test('can instantiate a ChatMessage object', () {
      final message = ChatMessage(
        id: 'message1',
        createdAt: DateTime.now(),
        profile: profile,
        content: 'Hello!',
        status: MessageStatus.sent,
      );

      expect(message.id, 'message1');
      expect(message.profile.username, 'John Doe');
      expect(message.content, 'Hello!');
      expect(message.status, MessageStatus.sent);
    });

    test('can check if the message is mine', () {
      // Mock the userId in GlobalStore
      when(() => mockGlobalStore.userId).thenReturn('user1');

      final message = ChatMessage(
        id: 'message1',
        createdAt: DateTime.now(),
        profile: profile,
        content: 'Hello!',
        status: MessageStatus.sent,
      );

      expect(message.isMine, isTrue);

      final otherMessage = ChatMessage(
        id: 'message2',
        createdAt: DateTime.now(),
        profile: otherProfile,
        content: 'Hi!',
        status: MessageStatus.sent,
      );

      expect(otherMessage.isMine, isFalse);
    });

    test('can serialize and deserialize ChatMessage', () {
      final message = ChatMessage(
        id: 'message1',
        createdAt: DateTime(2024, 10),
        profile: profile,
        content: 'Hello!',
        status: MessageStatus.sent,
      );

      // Serialize to JSON
      final json = message.toMap();
      expect(json['id'], 'message1');
      expect((json['profile'] as Map)['username'], 'John Doe');
      expect(json['content'], 'Hello!');
      expect(json['status'], 1);

      // Deserialize from JSON
      final deserializedMessage = ChatMessageMapper.fromMap(json);
      expect(deserializedMessage.id, 'message1');
      expect(deserializedMessage.profile.username, 'John Doe');
      expect(deserializedMessage.content, 'Hello!');
      expect(deserializedMessage.status, MessageStatus.sent);
    });
  });
}
