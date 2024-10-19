import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/views/chat_page.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/chat_page_body.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/chat_page_form.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';

import '../../../../test_utils/common_mocks.dart';
import '../../../../test_utils/utils.dart';

class MockChatCubit extends Mock implements ChatCubit {}

void main() {
  late ChatCubit mockChatCubit;
  late MockGoRouter mockGoRouter;
  late MockGlobalStore mockGlobalStore;

  final profile1 = Profile(
    id: 'user1',
    username: 'John',
    createdAt: DateTime(200, 06, 11),
    bio: '',
  );

  final profile2 = Profile(
    id: 'user2',
    username: 'Jane',
    createdAt: DateTime(200, 06, 11),
    bio: '',
  );

  var mockRoom = Room(
    id: 'room1',
    createdAt: DateTime.now(),
    participants: [profile1, profile2],
    unreadMessages: 3,
    lastMessage: 'Hello World',
    lastMessageStatus: MessageStatus.sent,
    lastSenderId: 'user1',
    lastMessageTimeSent: DateTime(2002, 06, 11, 15, 30),
  );

  setUp(() {
    mockChatCubit = MockChatCubit();
    mockGoRouter = MockGoRouter();
    mockGlobalStore = MockGlobalStore();

    mockRoom = Room(
      id: 'room1',
      createdAt: DateTime.now(),
      participants: [profile1, profile2],
      unreadMessages: 3,
      lastMessage: 'Hello World',
      lastMessageStatus: MessageStatus.sent,
      lastSenderId: 'user1',
      lastMessageTimeSent: DateTime(2002, 06, 11, 15, 30),
    );
    // Register mock GlobalStore to the service locator
    sl.registerSingleton<GlobalStore>(mockGlobalStore);
  });
  tearDown(sl.reset);

  Widget createWidgetUnderTest() {
    return MockGoRouterProvider(
      goRouter: mockGoRouter,
      child: MaterialApp(
        home: BlocProvider.value(
          value: mockChatCubit,
          child: ChatPage(room: mockRoom),
        ),
      ),
    );
  }

  group('ChatPage Tests', () {
    testWidgets('should display default profile icon if imageUrl is null',
        (WidgetTester tester) async {
      // Arrange
      whenListen(
        mockChatCubit,
        Stream<ChatState>.fromIterable([]),
        initialState: const ChatLoaded([]),
      );
      when(() => mockGlobalStore.userId).thenReturn('user1');

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.byType(SvgPicture),
        findsOneWidget,
      ); // Checks if default icon is displayed
    });

    testWidgets('should display network image when imageUrl is not null',
        (WidgetTester tester) async {
      // Arrange
      mockRoom = mockRoom.copyWith(
        participants: [
          profile1,
          profile2.copyWith(imageUrl: 'https://example.com/profile_image.png'),
        ],
      );

      whenListen(
        mockChatCubit,
        Stream<ChatState>.fromIterable([]),
        initialState: const ChatLoaded([]),
      );
      when(() => mockGlobalStore.userId).thenReturn('user1');
      // mockRoom = const Room(
      //   id: 'room_1',
      //   name: 'Test Room',
      //   imageUrl: 'https://example.com/profile_image.png',
      //   otherParticipant: 'participant_1',
      // );

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(
        find.byType(SvgPicture),
        findsNothing,
      ); // Default icon should not be shown
    });

    testWidgets('should navigate to contact details when tapped on AppBar',
        (WidgetTester tester) async {
      // Arrange
      whenListen(
        mockChatCubit,
        Stream<ChatState>.fromIterable([]),
        initialState: const ChatLoaded([]),
      );
      when(() => mockGlobalStore.userId).thenReturn('user1');
      when(
        () => mockGoRouter.pushNamed(
          any(),
          extra: any(named: 'extra'),
          pathParameters: any(named: 'pathParameters'),
        ),
      ).thenAnswer(
        (realInvocation) async {
          return null;
        },
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.tap(find.byKey(const Key('ChatPage-AppBarTitle')));
      await tester.pump();

      // Assert
      verify(
        () => mockGoRouter.pushNamed(
          AppRoutes.contact.name,
          extra: profile2,
          pathParameters: {'roomId': mockRoom.id},
        ),
      ).called(1);
    });

    testWidgets('should display room name in AppBar',
        (WidgetTester tester) async {
      // Arrange
      whenListen(
        mockChatCubit,
        Stream<ChatState>.fromIterable([]),
        initialState: const ChatLoaded([]),
      );
      when(() => mockGlobalStore.userId).thenReturn('user1');

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Jane'), findsOneWidget);
    });

    testWidgets('should display ChatPageBody and ChatPageForm in body',
        (WidgetTester tester) async {
      // Arrange
      whenListen(
        mockChatCubit,
        Stream<ChatState>.fromIterable([]),
        initialState: const ChatLoaded([]),
      );
      when(() => mockGlobalStore.userId).thenReturn('user1');

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ChatPageBody), findsOneWidget);
      expect(find.byType(ChatPageForm), findsOneWidget);
    });
  });
}
