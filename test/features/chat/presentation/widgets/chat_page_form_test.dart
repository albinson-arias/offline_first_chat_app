import 'package:bloc_test/bloc_test.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/chat_page_form.dart';

class MockChatCubit extends MockCubit<ChatState> implements ChatCubit {}

void main() {
  late MockChatCubit mockChatCubit;
  const roomId = 'roomId123';

  setUp(() {
    mockChatCubit = MockChatCubit();
  });

  testWidgets('initial state is correct with empty text field', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatCubit>(
          create: (context) => mockChatCubit,
          child: const Scaffold(
            body: ChatPageForm(roomId: roomId),
          ),
        ),
      ),
    );

    // Check that initially canSendMessage is false and the text field is empty
    final messageBar = find.byType(MessageBar);
    expect(messageBar, findsOneWidget);

    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    expect(find.text(''), findsOneWidget);
  });

  testWidgets('typing in the text field enables message sending',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatCubit>(
          create: (context) => mockChatCubit,
          child: const Scaffold(
            body: ChatPageForm(roomId: roomId),
          ),
        ),
      ),
    );

    // Find the text field and enter text
    final textField = find.byType(TextField);
    await tester.enterText(textField, 'Hello');
    await tester.pump();

    // Check that canSendMessage is true (via the messageBar)
    final messageBar = tester.widget<MessageBar>(find.byType(MessageBar));
    expect(messageBar.onSend != null, true);
  });

  testWidgets('sendMessage sends message and clears text field',
      (tester) async {
    whenListen(
      mockChatCubit,
      Stream<ChatState>.fromIterable([]),
      initialState: const ChatInitial(),
    );
    when(() => mockChatCubit.sendMessage(any(), any()))
        .thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatCubit>(
          create: (context) => mockChatCubit,
          child: const Scaffold(
            body: ChatPageForm(roomId: roomId),
          ),
        ),
      ),
    );

    // Enter text into the text field
    final textField = find.byType(TextField);
    await tester.enterText(textField, 'Test message');
    await tester.pump();

    // Simulate pressing send
    final messageBar = tester.widget<MessageBar>(find.byType(MessageBar));
    messageBar.onSend?.call('Test message');
    await tester.pump();

    // Verify that sendMessage was called with the correct arguments
    verify(() => mockChatCubit.sendMessage(roomId, 'Test message')).called(1);

    // Check that the text field is cleared after sending
    expect(find.text(''), findsOneWidget);
  });

  testWidgets('empty or blank messages cannot be sent', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatCubit>(
          create: (context) => mockChatCubit,
          child: const Scaffold(
            body: ChatPageForm(roomId: roomId),
          ),
        ),
      ),
    );

    // Find the text field and enter blank spaces
    final textField = find.byType(TextField);
    await tester.enterText(textField, '    ');
    await tester.pump();

    // Simulate pressing send with blank text
    final messageBar = tester.widget<MessageBar>(find.byType(MessageBar));
    messageBar.onSend?.call('    ');
    await tester.pump();

    // Verify that sendMessage was not called for blank text
    verifyNever(() => mockChatCubit.sendMessage(any(), any()));
  });
}
