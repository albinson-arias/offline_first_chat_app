import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/contacts_list.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/contacts_search_delegate.dart';

class MockContactsCubit extends Mock implements ContactsCubit {}

void main() {
  late MockContactsCubit mockContactsCubit;
  late List<Profile> mockProfiles;

  setUp(() {
    mockContactsCubit = MockContactsCubit();
    mockProfiles = [
      Profile(
        id: '123',
        createdAt: DateTime(2002, 06, 11),
        username: 'John Doe',
        bio: '',
      ),
    ];
  });

  group('ContactsSearchDelegate Tests', () {
    testWidgets('should show no results when contacts list is empty',
        (WidgetTester tester) async {
      // Arrange
      final delegate = ContactsSearchDelegate([], mockContactsCubit);

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

    testWidgets('should display the contacts list when suggestions are loaded',
        (WidgetTester tester) async {
      // Arrange
      final delegate = ContactsSearchDelegate(mockProfiles, mockContactsCubit);

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

    testWidgets('should clear the query when the clear button is pressed',
        (WidgetTester tester) async {
      // Arrange
      final delegate = ContactsSearchDelegate(mockProfiles, mockContactsCubit)
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

      // Check if query is not empty initially
      expect(delegate.query, 'John');

      // Clear the query
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Assert
      expect(delegate.query, ''); // Should be cleared now
    });

    testWidgets('should close search when back button is pressed',
        (WidgetTester tester) async {
      // Arrange
      final delegate = ContactsSearchDelegate(mockProfiles, mockContactsCubit);

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

      // Press the back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
