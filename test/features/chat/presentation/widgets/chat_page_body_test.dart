import 'package:bloc_test/bloc_test.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_elastic_list_view/flutter_elastic_list_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/chat_page_body.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';

import '../../../../test_utils/common_mocks.dart';

class MockChatCubit extends Mock implements ChatCubit {}

void main() {
  late ChatCubit mockChatCubit;
  late MockGlobalStore mockGlobalStore;

  setUp(() {
    mockChatCubit = MockChatCubit();
    mockGlobalStore = MockGlobalStore();
    // Inject the mockGlobalStore into the service locator
    sl.registerSingleton<GlobalStore>(mockGlobalStore);
  });

  tearDown(sl.reset);

  testWidgets('shows CircularProgressIndicator when loading', (tester) async {
    whenListen(
      mockChatCubit,
      Stream<ChatState>.fromIterable([]),
      initialState: const ChatLoading(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockChatCubit,
          child: const Scaffold(
            body: Column(
              children: [
                ChatPageBody(),
              ],
            ),
          ),
        ),
      ),
    );

    // Verify that the CircularProgressIndicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays messages correctly when ChatLoaded state is provided',
      (tester) async {
    final messages = [
      ChatMessage(
        content: 'Hello',
        profile: Profile(
          id: '1',
          createdAt: DateTime(2002, 06, 11),
          username: '',
          bio: '',
        ),
        id: '',
        createdAt: DateTime(2002, 06, 11),
        status: MessageStatus.sent,
      ),
      ChatMessage(
        content: 'Hi there',
        profile: Profile(
          id: '2',
          createdAt: DateTime(2002, 06, 11),
          username: '',
          bio: '',
        ),
        id: '',
        createdAt: DateTime(2002, 06, 11),
        status: MessageStatus.sent,
      ),
    ];
    whenListen(
      mockChatCubit,
      Stream<ChatState>.fromIterable([]),
      initialState: ChatLoaded(messages),
    );
    when(
      () => mockGlobalStore.userId,
    ).thenReturn('1');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: BlocProvider.value(
              value: mockChatCubit,
              child: const Scaffold(
                body: Column(
                  children: [
                    ChatPageBody(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the list displays the correct number of messages
    expect(find.byType(BubbleSpecialThree), findsNWidgets(messages.length));
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Hi there'), findsOneWidget);
  });

  testWidgets('displays tail correctly based on message order', (tester) async {
    final messages = [
      ChatMessage(
        content: 'Hello',
        profile: Profile(
          id: '1',
          createdAt: DateTime(2002, 06, 11),
          username: '',
          bio: '',
        ),
        id: '',
        createdAt: DateTime(2002, 06, 11),
        status: MessageStatus.sent,
      ),
      ChatMessage(
        content: 'How are you?',
        profile: Profile(
          id: '1',
          createdAt: DateTime(2002, 06, 11),
          username: '',
          bio: '',
        ),
        id: '',
        createdAt: DateTime(2002, 06, 11),
        status: MessageStatus.sent,
      ),
      ChatMessage(
        content: 'Hi there',
        profile: Profile(
          id: '2',
          createdAt: DateTime(2002, 06, 11),
          username: '',
          bio: '',
        ),
        id: '',
        createdAt: DateTime(2002, 06, 11),
        status: MessageStatus.sent,
      ),
    ];
    whenListen(
      mockChatCubit,
      Stream<ChatState>.fromIterable([]),
      initialState: ChatLoaded(messages),
    );
    when(
      () => mockGlobalStore.userId,
    ).thenReturn('1');

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockChatCubit,
          child: const Scaffold(
            body: Column(
              children: [
                ChatPageBody(),
              ],
            ),
          ),
        ),
      ),
    );

    final bubbles = tester
        .widgetList<BubbleSpecialThree>(find.byType(BubbleSpecialThree))
        .toList();

    // Verify the tail is displayed on the first
    // and last messages but not the middle one
    expect(bubbles[0].tail, isTrue); // First message from the user
    expect(bubbles[1].tail, isFalse); // Same user, should not have tail
    expect(bubbles[2].tail, isTrue); // Different user, should have tail
  });

  testWidgets('ensures list is reversed with latest messages at the bottom',
      (tester) async {
    final messages = [
      ChatMessage(
        content: 'Latest Message',
        profile: Profile(
          id: '1',
          createdAt: DateTime(2002, 06, 11),
          username: '',
          bio: '',
        ),
        id: '',
        createdAt: DateTime(2002, 06, 11),
        status: MessageStatus.sent,
      ),
      ChatMessage(
        content: 'First Message',
        profile: Profile(
          id: '1',
          createdAt: DateTime(2002, 06, 11),
          username: '',
          bio: '',
        ),
        id: '',
        createdAt: DateTime(2002, 06, 11),
        status: MessageStatus.sent,
      ),
    ];
    whenListen(
      mockChatCubit,
      Stream<ChatState>.fromIterable([]),
      initialState: ChatLoaded(messages),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockChatCubit,
          child: const Scaffold(
            body: Column(
              children: [
                ChatPageBody(),
              ],
            ),
          ),
        ),
      ),
    );

    // Check that the FlutterListView is reversed
    final listView =
        tester.widget<ElasticListView>(find.byType(ElasticListView));
    expect(listView.reverse, isTrue);

    // Verify the order of the messages (latest at the bottom)
    final bubbles = tester
        .widgetList<BubbleSpecialThree>(find.byType(BubbleSpecialThree))
        .toList();
    expect(bubbles[0].text, 'Latest Message'); // Appears last
    expect(bubbles[1].text, 'First Message'); // Appears first
  });
}
