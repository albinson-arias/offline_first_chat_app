import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/add_contacts_cubit/add_contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/views/contacts_page.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/contacts_list.dart';
import 'package:offline_first_chat_app/src/common/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';

import '../../../../test_utils/common_mocks.dart';
import '../../../../test_utils/utils.dart';

class MockContactsCubit extends MockCubit<ContactsState>
    implements ContactsCubit {}

class MockAddContactsCubit extends MockCubit<AddContactsState>
    implements AddContactsCubit {}

class MockBottomNavBarCubit extends MockCubit<int>
    implements BottomNavBarCubit {}

void main() {
  late ContactsCubit mockContactsCubit;
  late MockBottomNavBarCubit mockBottomNavBarCubit;
  late MockAddContactsCubit mockAddContactsCubit;
  late MockGoRouter mockRouter;

  setUp(() {
    mockContactsCubit = MockContactsCubit();
    mockBottomNavBarCubit = MockBottomNavBarCubit();
    mockAddContactsCubit = MockAddContactsCubit();
    mockRouter = MockGoRouter();
    sl
      ..registerSingleton<BottomNavBarCubit>(mockBottomNavBarCubit)
      ..registerSingleton<AddContactsCubit>(mockAddContactsCubit);
    when(() => mockContactsCubit.state).thenReturn(const ContactsLoading());
  });

  tearDown(sl.reset);

  setUpAll(
    () {
      registerFallbackValue(
        Room(
          id: '123',
          createdAt: DateTime.now(),
          participants: [],
          unreadMessages: 0,
          lastMessage: 'Hello',
          lastMessageStatus: MessageStatus.read,
          lastSenderId: '1',
          lastMessageTimeSent: DateTime.now(),
        ),
      );
    },
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MockGoRouterProvider(
        goRouter: mockRouter,
        child: BlocProvider.value(
          value: mockContactsCubit,
          child: const ContactsPage(),
        ),
      ),
    );
  }

  testWidgets(
      'displays CircularProgressIndicator when state is ContactsLoading',
      (tester) async {
    when(() => mockContactsCubit.state).thenReturn(const ContactsLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays ContactsList when state is ContactsLoaded',
      (tester) async {
    final profiles = [
      Profile(
        id: '1',
        createdAt: DateTime.now(),
        username: 'John Doe',
        bio: 'Bio of John Doe',
      ),
    ];
    when(() => mockContactsCubit.state).thenReturn(ContactsLoaded(profiles));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(ContactsList), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('1 contacts'), findsOneWidget);
  });

  testWidgets('navigates to room when state is ContactsNavigateToRoom',
      (tester) async {
    when(
      () => mockRouter.goNamed(
        any(),
        pathParameters: any(named: 'pathParameters'),
        extra: any(named: 'extra'),
      ),
    ).thenAnswer(
      (invocation) async {
        return;
      },
    );
    final profiles = [
      Profile(
        id: '1',
        createdAt: DateTime.now(),
        username: 'John Doe',
        bio: 'Bio of John Doe',
      ),
    ];
    final room = Room(
      id: '123',
      createdAt: DateTime.now(),
      participants: profiles,
      unreadMessages: 0,
      lastMessage: 'Hello',
      lastMessageStatus: MessageStatus.read,
      lastSenderId: '1',
      lastMessageTimeSent: DateTime.now(),
    );
    whenListen(
      mockContactsCubit,
      Stream.fromIterable([ContactsNavigateToRoom(room)]),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Let the UI react to the state change

    // Verify navigation to chat route
    verify(() => mockBottomNavBarCubit.navigateToHome()).called(1);
    verify(
      () => mockRouter.goNamed(
        AppRoutes.chat.name,
        pathParameters: {'roomId': room.id},
        extra: room,
      ),
    ).called(1);
  });

  testWidgets('opens ContactsSearchDelegate when search button is tapped',
      (tester) async {
    final profiles = [
      Profile(
        id: '1',
        createdAt: DateTime.now(),
        username: 'John Doe',
        bio: 'Bio of John Doe',
      ),
    ];

    when(() => mockContactsCubit.state).thenReturn(ContactsLoaded(profiles));

    await tester.pumpWidget(createWidgetUnderTest());

    // Tap on the search button to trigger the SearchDelegate
    final searchButton = find.byIcon(Icons.search);
    await tester.tap(searchButton);

    // Wait for the SearchDelegate route to be pushed
    await tester.pumpAndSettle();

    // Verify that the search is open by checking for a UI element that
    // appears when SearchDelegate is active
    expect(
      find.byType(TextField),
      findsOneWidget,
    ); // The search bar input field
  });

  testWidgets('opens AddContactsSearchDelegate when "Add Contacts" is tapped',
      (tester) async {
    await tester.runAsync(
      () async {
        final profiles = [
          Profile(
            id: '1',
            createdAt: DateTime.now(),
            username: 'John Doe',
            bio: 'Bio of John Doe',
          ),
        ];
        when(() => mockContactsCubit.state)
            .thenReturn(ContactsLoaded(profiles));
        when(() => mockAddContactsCubit.state)
            .thenReturn(AddContactsLoaded(profiles));
        when(
          () => mockAddContactsCubit.searchProfiles(
            any(),
          ),
        ).thenAnswer(
          (realInvocation) async => {},
        );

        await tester.pumpWidget(createWidgetUnderTest());

        final addContactsTile = find.text('Add Contacts');
        await tester.tap(addContactsTile);

        await tester.pumpAndSettle();

        await Future<void>.delayed(const Duration(milliseconds: 500));

        // Verify that the search is open by checking for a UI element that
        // appears when SearchDelegate is active
        expect(
          find.byType(TextField),
          findsOneWidget,
        );
      },
    );
  });
}
