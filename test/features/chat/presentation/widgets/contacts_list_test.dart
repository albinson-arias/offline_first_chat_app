import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/contacts_list.dart';

class MockContactsCubit extends MockCubit<ContactsState>
    implements ContactsCubit {}

void main() {
  late MockContactsCubit mockContactsCubit;
  late List<Profile> contacts;

  final profile = Profile(
    username: 'John Doe',
    id: '',
    createdAt: DateTime(2002, 06, 11),
    bio: '',
  );

  setUpAll(() {
    registerFallbackValue(profile);
  });

  setUp(() {
    mockContactsCubit = MockContactsCubit();
    contacts = [
      profile,
      Profile(
        username: 'Jane Doe',
        imageUrl: 'https://example.com/image.jpg',
        id: '',
        createdAt: DateTime(2002, 06, 11),
        bio: '',
      ),
    ];
  });

  testWidgets('renders the correct number of contacts and header',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContactsList(contacts: contacts),
        ),
      ),
    );

    // Check if the header text is displayed
    expect(find.text('Contacts on OfflineFirstChatApp'), findsOneWidget);

    // Check if the correct number of ListTiles
    // (one for each contact) is rendered
    expect(find.byType(ListTile), findsNWidgets(contacts.length));
  });

  testWidgets('displays profile icon when imageUrl is null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContactsList(contacts: contacts),
        ),
      ),
    );

    // Check if the first contact (John Doe) has the default profile icon
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('displays CachedNetworkImage when imageUrl is present',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContactsList(contacts: contacts),
        ),
      ),
    );

    // Check if the second contact (Jane Doe) has a CachedNetworkImage
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('shows CircularProgressIndicator while the image is loading',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContactsList(contacts: contacts),
        ),
      ),
    );

    // Check if CircularProgressIndicator is shown while the image is loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('calls loadRoom and shows loading dialog on contact tap',
      (tester) async {
    when(() => mockContactsCubit.loadRoom(any())).thenAnswer(
      (invocation) async {},
    );
    whenListen(
      mockContactsCubit,
      Stream<ContactsState>.fromIterable([]),
      initialState: const ContactsInitial(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ContactsCubit>(
          create: (_) => mockContactsCubit,
          child: Scaffold(
            body: ContactsList(
              contacts: [
                profile.copyWith(imageUrl: null),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate tapping the first contact (John Doe)
    await tester.tap(find.text('John Doe'));
    await tester.pump();

    // Verify that loadRoom was called with the correct contact
    verify(() => mockContactsCubit.loadRoom(contacts.first)).called(1);

    // Since CoreUtils.showLoadingDialog is expected to be called,
    // we should check if a loading indicator appears.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
