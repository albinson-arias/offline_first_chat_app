import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/chat_list_tile.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';

import '../../../../test_utils/common_mocks.dart';
import '../../../../test_utils/utils.dart';

void main() {
  late MockGoRouter mockRouter;
  late MockGlobalStore mockGlobalStore;

  tearDown(sl.reset);

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

  var room = Room(
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
    mockRouter = MockGoRouter();
    mockGlobalStore = MockGlobalStore();
    // Register mock GlobalStore to the service locator
    sl.registerSingleton<GlobalStore>(mockGlobalStore);
    room = Room(
      id: 'room1',
      createdAt: DateTime.now(),
      participants: [profile1, profile2],
      unreadMessages: 3,
      lastMessage: 'Hello World',
      lastMessageStatus: MessageStatus.sent,
      lastSenderId: 'user1',
      lastMessageTimeSent: DateTime(2002, 06, 11, 15, 30),
    );
  });

  setUpAll(
    () {
      registerFallbackValue(room);
    },
  );

  testWidgets('renders RoomListTile correctly with default data',
      (tester) async {
    when(() => mockGlobalStore.userId).thenReturn('user1');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoomListTile(room: room),
        ),
      ),
    );

    // Check if room name is displayed
    expect(find.text('Jane'), findsOneWidget);

    // Check if last message is displayed
    expect(find.text('Hello World'), findsOneWidget);

    // Check if unread messages badge is displayed
    expect(find.text('3'), findsOneWidget);

    // Check if time is displayed correctly
    expect(find.text('15:30'), findsOneWidget);
  });

  testWidgets('navigates to the chat page on tap', (tester) async {
    when(
      () => mockRouter.pushNamed(
        any(),
        pathParameters: any(named: 'pathParameters'),
        extra: any(named: 'extra'),
      ),
    ).thenAnswer(
      (invocation) async {
        return null;
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MockGoRouterProvider(
          goRouter: mockRouter,
          child: Scaffold(
            body: RoomListTile(room: room),
          ),
        ),
      ),
    );

    // Simulate a tap on the RoomListTile
    await tester.tap(find.byType(RoomListTile));
    await tester.pumpAndSettle();

    // Verify the navigation call
    verify(
      () => mockRouter.pushNamed(
        any(),
        pathParameters: {'roomId': room.id},
        extra: room,
      ),
    ).called(1);
  });

  testWidgets('displays correct message status icon', (tester) async {
    when(() => mockGlobalStore.userId).thenReturn('user1');
    room = room.copyWith(
      lastMessageStatus: MessageStatus.sent,
      lastSenderId: 'user1',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoomListTile(room: room),
        ),
      ),
    );

    // Check if the sent status icon is displayed
    expect(find.byIcon(Icons.done_rounded), findsOneWidget);
  });

  testWidgets('displays bold font when there are unread messages',
      (tester) async {
    room = room.copyWith(unreadMessages: 3);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoomListTile(room: room),
        ),
      ),
    );

    final lastMessageFinder = find.text('Hello World');
    final lastMessageText = tester.widget(lastMessageFinder) as Text;

    // Check if the fontWeight is bold
    expect(lastMessageText.style!.fontWeight, FontWeight.bold);
  });

  testWidgets('does not display unread messages when count is 0',
      (tester) async {
    room = room.copyWith(unreadMessages: 0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoomListTile(room: room),
        ),
      ),
    );

    // Check if unread messages badge is not displayed
    expect(find.text('3'), findsNothing);
  });

  testWidgets('displays profile icon when imageUrl is null', (tester) async {
    // Testing case where imageUrl is null, so the default
    // profile icon should be displayed
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoomListTile(room: room),
        ),
      ),
    );

    // Check if the profile icon is shown when imageUrl is null
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('displays CachedNetworkImage when imageUrl is present',
      (tester) async {
    room = room.copyWith(
      participants: [
        profile1.copyWith(imageUrl: 'https://example.com/image.jpg'),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoomListTile(room: room),
        ),
      ),
    );

    // Check if CachedNetworkImage is used when imageUrl is provided
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('shows CircularProgressIndicator while the image is loading',
      (tester) async {
    room = room.copyWith(
      participants: [
        profile1.copyWith(imageUrl: 'https://example.com/image.jpg'),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoomListTile(room: room),
        ),
      ),
    );

    // Simulate the image loading process by finding the progress indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
