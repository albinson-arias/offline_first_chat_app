import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';

void main() {
  group('ChatState Tests', () {
    final profile = Profile(
      id: '1',
      username: 'John Doe',
      imageUrl: 'image1.png',
      bio: '',
      createdAt: DateTime(2002, 06, 11),
    );
    final otherProfile = Profile(
      id: '2',
      username: 'Albinson Arias',
      imageUrl: 'image1.png',
      bio: '',
      createdAt: DateTime(2002, 06, 11),
    );
    test('ChatInitial can be instantiated', () {
      const state = ChatInitial();
      expect(state, isA<ChatInitial>());
    });

    test('ChatLoading can be instantiated', () {
      const state = ChatLoading();
      expect(state, isA<ChatLoading>());
    });

    test('ChatLoaded can be instantiated with a list of messages', () {
      final messages = [
        ChatMessage(
          id: 'msg1',
          createdAt: DateTime.now(),
          profile: profile,
          content: 'Hello!',
          status: MessageStatus.sent,
        ),
        ChatMessage(
          id: 'msg2',
          createdAt: DateTime.now(),
          profile: otherProfile,
          content: 'Hi!',
          status: MessageStatus.read,
        ),
      ];
      final state = ChatLoaded(messages);

      expect(state.messages, messages);
      expect(state.messages.length, 2);
    });

    test('ChatLoaded props returns correct values', () {
      final messages = [
        ChatMessage(
          id: 'msg1',
          createdAt: DateTime.now(),
          profile: profile,
          content: 'Hello!',
          status: MessageStatus.sent,
        ),
      ];
      final state = ChatLoaded(messages);

      expect(state.props, [messages]);
    });

    test('ChatState equality works correctly', () {
      final messages = [
        ChatMessage(
          id: 'msg1',
          createdAt: DateTime.now(),
          profile: profile,
          content: 'Hello!',
          status: MessageStatus.sent,
        ),
      ];
      final state1 = ChatLoaded(messages);
      final state2 = ChatLoaded(messages);

      expect(state1, equals(state2));

      const initial1 = ChatInitial();
      const initial2 = ChatInitial();
      expect(initial1, equals(initial2));

      const loading1 = ChatLoading();
      const loading2 = ChatLoading();
      expect(loading1, equals(loading2));
    });
  });
}
