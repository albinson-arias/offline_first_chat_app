import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/add_contacts_cubit/add_contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/add_contact_search_delegate.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/contacts_list.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/core/utils/debouncer.dart';

class MockAddContactsCubit extends Mock implements AddContactsCubit {}

class MockContactsCubit extends Mock implements ContactsCubit {}

class MockDebouncer extends Mock implements Debouncer {}

void main() {
  late MockAddContactsCubit mockAddContactsCubit;
  late MockContactsCubit mockContactsCubit;
  late Debouncer mockdebouncer;

  setUpAll(() {
    registerFallbackValue(const AddContactsInitial());
  });

  setUp(() {
    mockAddContactsCubit = MockAddContactsCubit();
    mockContactsCubit = MockContactsCubit();
    mockdebouncer = MockDebouncer();
    sl.registerFactory<AddContactsCubit>(() => mockAddContactsCubit);
  });

  tearDown(sl.reset);

  group('AddContactsSearchDelegate Tests', () {
    testWidgets('should show no results when contacts list is empty',
        (WidgetTester tester) async {
      // Arrange
      whenListen(
        mockAddContactsCubit,
        Stream<AddContactsState>.fromIterable([]),
        initialState: const AddContactsLoaded([]),
      );

      final delegate = AddContactsSearchDelegate(
        contactsCubit: mockContactsCubit,
        debouncer: mockdebouncer,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () async {
                    await showSearch<Profile?>(
                      context: context,
                      delegate: delegate,
                    );
                  },
                  icon: const Icon(Icons.search),
                );
              },
            ),
          ),
        ),
      );

      // Trigger the search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No Results'), findsOneWidget);
    });

    testWidgets('should display the contacts list when contacts are loaded',
        (WidgetTester tester) async {
      // Arrange
      final profile = Profile(
        id: '123',
        createdAt: DateTime(2002, 06, 11),
        username: 'John Doe',
        bio: '',
      );

      whenListen(
        mockAddContactsCubit,
        Stream<AddContactsState>.fromIterable([]),
        initialState: AddContactsLoaded([profile]),
      );

      final delegate = AddContactsSearchDelegate(
        contactsCubit: mockContactsCubit,
        debouncer: mockdebouncer,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () async {
                    await showSearch<Profile?>(
                      context: context,
                      delegate: delegate,
                    );
                  },
                  icon: const Icon(Icons.search),
                );
              },
            ),
          ),
        ),
      );

      // Trigger the search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ContactsList), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should show CircularProgressIndicator when state is loading',
        (WidgetTester tester) async {
      await tester.runAsync(
        () async {
          // Arrange
          whenListen(
            mockAddContactsCubit,
            Stream<AddContactsState>.fromIterable([]),
            initialState: const AddContactsLoading(),
          );

          final delegate = AddContactsSearchDelegate(
            contactsCubit: mockContactsCubit,
            debouncer: mockdebouncer,
          );

          // Act
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () async {
                        await showSearch<Profile?>(
                          context: context,
                          delegate: delegate,
                        );
                      },
                      icon: const Icon(Icons.search),
                    );
                  },
                ),
              ),
            ),
          );

          // Trigger the search
          await tester.tap(find.byIcon(Icons.search));
          await tester.pump();
          await Future<void>.delayed(const Duration(milliseconds: 500));
          await tester.pump();

          // Assert
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );
    });

    testWidgets('should call searchProfiles on debouncer run',
        (WidgetTester tester) async {
      await tester.runAsync(
        () async {
          // Arrange
          whenListen(
            mockAddContactsCubit,
            Stream<AddContactsState>.fromIterable([]),
            initialState: const AddContactsLoading(),
          );
          when(() => mockAddContactsCubit.searchProfiles(any()))
              .thenAnswer((_) async {});

          final delegate = AddContactsSearchDelegate(
            contactsCubit: mockContactsCubit,
            debouncer: Debouncer(milliseconds: 100),
          );

          // Act
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () async {
                        await showSearch<Profile?>(
                          context: context,
                          delegate: delegate,
                        );
                      },
                      icon: const Icon(Icons.search),
                    );
                  },
                ),
              ),
            ),
          );

          // Trigger the search and enter a query
          await tester.tap(find.byIcon(Icons.search));
          await tester.pump();
          delegate.query = 'John';

          await Future<void>.delayed(const Duration(milliseconds: 500));
          await tester.pump(const Duration(milliseconds: 600));
          // await tester.pump(const Duration(seconds: 1));

          // Assert
          verify(() => mockAddContactsCubit.searchProfiles('John')).called(1);
        },
      );
    });

    testWidgets('should close cubit when dispose is called',
        (WidgetTester tester) async {
      // Arrange
      when(
        () => mockAddContactsCubit.close(),
      ).thenAnswer(
        (realInvocation) async {},
      );
      AddContactsSearchDelegate(contactsCubit: mockContactsCubit)

          // Act
          .dispose();

      // Assert
      verify(() => mockAddContactsCubit.close()).called(1);
    });
  });

  testWidgets('should clear query or close search when clear button is pressed',
      (WidgetTester tester) async {
    await tester.runAsync(
      () async {
        // Arrange
        whenListen(
          mockAddContactsCubit,
          Stream<AddContactsState>.fromIterable([]),
          initialState: const AddContactsLoaded([]),
        );

        when(
          () => mockAddContactsCubit.searchProfiles(
            any(),
          ),
        ).thenAnswer(
          (realInvocation) async {},
        );

        final delegate =
            AddContactsSearchDelegate(contactsCubit: mockContactsCubit)
              ..query = 'John'; // Set initial query

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () async {
                      await showSearch<Profile?>(
                        context: context,
                        delegate: delegate,
                      );
                    },
                    icon: const Icon(Icons.search),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'John');
        await tester.pumpAndSettle();
        await Future<void>.delayed(const Duration(milliseconds: 500));

        // Check if query is not empty initially
        expect(delegate.query, 'John');

        // Clear the query
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        // Assert
        expect(delegate.query, ''); // Should be cleared now
      },
    );
  });

  testWidgets('should close search when back button is pressed',
      (WidgetTester tester) async {
    await tester.runAsync(
      () async {
        // Arrange
        whenListen(
          mockAddContactsCubit,
          Stream<AddContactsState>.fromIterable([]),
          initialState: const AddContactsLoaded([]),
        );

        when(
          () => mockAddContactsCubit.searchProfiles(
            any(),
          ),
        ).thenAnswer(
          (realInvocation) async {},
        );

        final delegate =
            AddContactsSearchDelegate(contactsCubit: mockContactsCubit);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () async {
                      await showSearch<Profile?>(
                        context: context,
                        delegate: delegate,
                      );
                    },
                    icon: const Icon(Icons.search),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();
        await Future<void>.delayed(const Duration(milliseconds: 500));

        // Press the back button
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pump();

        // Assert
        // Since `close` is triggered, there should be no more results shown
        expect(find.byIcon(Icons.search), findsOneWidget);
      },
    );
  });

  testWidgets('should show contacts list or no results in buildResults',
      (WidgetTester tester) async {
    await tester.runAsync(
      () async {
        // Arrange
        final profile = Profile(
          username: 'John Doe',
          id: '123',
          createdAt: DateTime(2002, 06, 11),
          bio: '',
        );

        whenListen(
          mockAddContactsCubit,
          Stream<AddContactsState>.fromIterable([]),
          initialState: AddContactsLoaded([profile]),
        );

        when(
          () => mockAddContactsCubit.searchProfiles(
            any(),
          ),
        ).thenAnswer(
          (realInvocation) async {},
        );

        final delegate =
            AddContactsSearchDelegate(contactsCubit: mockContactsCubit);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () async {
                      await showSearch<Profile?>(
                        context: context,
                        delegate: delegate,
                      );
                    },
                    icon: const Icon(Icons.search),
                  );
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();
        await Future<void>.delayed(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(ContactsList), findsOneWidget);
        expect(find.text('John Doe'), findsOneWidget);
      },
    );
    // // Simulate an empty list
    // whenListen(
    //   mockAddContactsCubit,
    //   Stream<AddContactsState>.fromIterable([]),
    //   initialState: const AddContactsLoaded([]),
    // );
    // await tester.pumpAndSettle();

    // // Assert for no results
    // expect(find.text('No Results'), findsOneWidget);
  });
}
