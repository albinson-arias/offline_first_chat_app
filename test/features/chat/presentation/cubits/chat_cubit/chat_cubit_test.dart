import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {}

void main() {
  late MockChatRepository mockChatRepository;
  late ChatCubit chatCubit;
  late MockStreamSubscription<List<ChatMessage>> mockSubscription;

  setUp(() {
    mockChatRepository = MockChatRepository();
    chatCubit = ChatCubit(chatRepository: mockChatRepository);
    mockSubscription = MockStreamSubscription<List<ChatMessage>>();
  });

  tearDown(() {
    chatCubit.close();
  });

  group('ChatCubit Tests', () {
    final profile = Profile(
      id: '1',
      username: 'John Doe',
      imageUrl: 'image1.png',
      bio: '',
      createdAt: DateTime(2002, 06, 11),
    );
    test('initial state is ChatInitial', () {
      expect(chatCubit.state, equals(const ChatInitial()));
    });

    blocTest<ChatCubit, ChatState>(
      'emits [ChatLoading, ChatLoaded] when loadChat is called',
      setUp: () {
        // Mock the repository to return a stream of messages
        final messages = [
          ChatMessage(
            id: 'msg1',
            createdAt: DateTime(2002, 06, 11),
            profile: profile,
            content: 'Hello!',
            status: MessageStatus.sent,
          ),
        ];
        when(() => mockChatRepository.getMessagesForRoom('room1'))
            .thenAnswer((_) => Stream.value(messages));
      },
      build: () => chatCubit,
      act: (cubit) => cubit.loadChat('room1'),
      expect: () => [
        const ChatLoading(),
        ChatLoaded([
          ChatMessage(
            id: 'msg1',
            createdAt: DateTime(2002, 06, 11),
            profile: profile,
            content: 'Hello!',
            status: MessageStatus.sent,
          ),
        ]),
      ],
      verify: (_) {
        verify(() => mockChatRepository.getMessagesForRoom('room1')).called(1);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'closes the stream subscription when the cubit is closed',
      build: () {
        // Return a stream and mock the subscription
        when(() => mockChatRepository.getMessagesForRoom('room1'))
            .thenAnswer((_) => const Stream.empty());
        when(
          () => mockSubscription.cancel(),
        ).thenAnswer(
          (realInvocation) async {},
        );
        return chatCubit;
      },
      act: (cubit) {
        cubit.loadChat('room1');
        return cubit.close();
      },
      verify: (_) async {
        await mockSubscription.cancel();
        verify(() => mockSubscription.cancel()).called(1);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'sends a message using the repository when sendMessage is called',
      build: () => chatCubit,
      setUp: () {
        when(() => mockChatRepository.sendMessage('room1', 'Hello'))
            .thenAnswer((_) async => {});
      },
      act: (cubit) => cubit.sendMessage('room1', 'Hello'),
      verify: (_) {
        verify(() => mockChatRepository.sendMessage('room1', 'Hello'))
            .called(1);
      },
    );
  });
}
