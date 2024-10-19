import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockChatRepository;
  late ContactsCubit contactsCubit;

  final profile = Profile(
    id: '1',
    username: 'John Doe',
    imageUrl: 'image1.png',
    bio: '',
    createdAt: DateTime(2002, 06, 11),
  );
  setUp(() {
    mockChatRepository = MockChatRepository();
    contactsCubit = ContactsCubit(chatRepository: mockChatRepository);
  });

  tearDown(() {
    contactsCubit.close();
  });

  setUpAll(() {
    registerFallbackValue(profile);
  });

  group('ContactsCubit Tests', () {
    final contacts = [
      profile,
      Profile(
        id: '2',
        username: 'Jane Doe',
        imageUrl: 'image2.png',
        bio: '',
        createdAt: DateTime(2002, 06, 11),
      ),
    ];
    test('initial state is ContactsInitial', () {
      expect(contactsCubit.state, equals(const ContactsInitial()));
    });

    blocTest<ContactsCubit, ContactsState>(
      'emits [ContactsLoading, ContactsLoaded] when'
      ' loadContacts is called successfully',
      setUp: () {
        when(() => mockChatRepository.getContacts()).thenAnswer(
          (_) async => contacts,
        );
      },
      build: () => contactsCubit,
      act: (cubit) => cubit.loadContacts(),
      expect: () => [
        const ContactsLoading(),
        ContactsLoaded(contacts),
      ],
      verify: (_) {
        verify(() => mockChatRepository.getContacts()).called(1);
      },
    );

    blocTest<ContactsCubit, ContactsState>(
      'emits [ContactsLoading, ContactsNavigateToRoom] when'
      ' loadRoom is called and room exists',
      setUp: () {
        final room = Room(
          id: 'room1',
          createdAt: DateTime(2002, 06, 11),
          participants: [
            profile,
          ],
          unreadMessages: 0,
        );
        when(() => mockChatRepository.getRoomWithParticipant('1')).thenAnswer(
          (_) async => room,
        );
      },
      build: () => contactsCubit,
      act: (cubit) => cubit.loadRoom(profile),
      expect: () => [
        const ContactsLoading(),
        ContactsNavigateToRoom(
          Room(
            id: 'room1',
            createdAt: DateTime(2002, 06, 11),
            participants: [
              profile,
            ],
            unreadMessages: 0,
          ),
        ),
      ],
      verify: (_) {
        verify(() => mockChatRepository.getRoomWithParticipant('1')).called(1);
      },
    );

    blocTest<ContactsCubit, ContactsState>(
      'emits [ContactsLoading, ContactsNavigateToRoom] when loadRoom'
      ' is called and room does not exist (starts a new conversation)',
      setUp: () {
        final room = Room(
          id: 'newRoom',
          createdAt: DateTime(2002, 06, 11),
          participants: [
            profile,
          ],
          unreadMessages: 0,
        );
        when(() => mockChatRepository.getRoomWithParticipant('1')).thenAnswer(
          (_) async => null,
        );
        when(() => mockChatRepository.startConversation(any())).thenAnswer(
          (_) async => room,
        );
      },
      build: () => contactsCubit,
      act: (cubit) => cubit.loadRoom(profile),
      expect: () => [
        const ContactsLoading(),
        ContactsNavigateToRoom(
          Room(
            id: 'newRoom',
            createdAt: DateTime(2002, 06, 11),
            participants: [
              profile,
            ],
            unreadMessages: 0,
          ),
        ),
      ],
      verify: (_) {
        verify(() => mockChatRepository.getRoomWithParticipant('1')).called(1);
        verify(() => mockChatRepository.startConversation(any())).called(1);
      },
    );
  });
}
