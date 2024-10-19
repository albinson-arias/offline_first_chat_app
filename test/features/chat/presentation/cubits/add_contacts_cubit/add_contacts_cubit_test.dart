import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/add_contacts_cubit/add_contacts_cubit.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockChatRepository;
  late AddContactsCubit addContactsCubit;

  setUp(() {
    mockChatRepository = MockChatRepository();
    addContactsCubit = AddContactsCubit(chatRepository: mockChatRepository);
  });

  tearDown(() {
    addContactsCubit.close();
  });

  group('AddContactsCubit Tests', () {
    final profile = Profile(
      id: '1',
      username: 'John Doe',
      imageUrl: 'image1.png',
      createdAt: DateTime(2002, 06, 11),
      bio: '',
    );

    test('initial state is AddContactsLoaded with an empty list', () {
      expect(addContactsCubit.state, const AddContactsLoaded([]));
    });

    blocTest<AddContactsCubit, AddContactsState>(
      'emits [AddContactsLoading, AddContactsLoaded] when searchProfiles'
      ' is called successfully',
      setUp: () {
        // Mock the repository to return a list of profiles
        // when searchProfiles is called
        when(() => mockChatRepository.searchProfiles('John')).thenAnswer(
          (_) async => [
            profile,
          ],
        );
      },
      build: () => addContactsCubit,
      act: (cubit) => cubit.searchProfiles('John'),
      expect: () => [
        const AddContactsLoading(),
        AddContactsLoaded([
          profile,
        ]),
      ],
      verify: (_) {
        // Verify that the searchProfiles method was called once
        verify(() => mockChatRepository.searchProfiles('John')).called(1);
      },
    );

    blocTest<AddContactsCubit, AddContactsState>(
      'emits [AddContactsLoading, AddContactsLoaded] with an empty'
      ' list when searchProfiles returns no results',
      setUp: () {
        // Mock the repository to return
        // an empty list when searchProfiles is called
        when(() => mockChatRepository.searchProfiles('Unknown')).thenAnswer(
          (_) async => [],
        );
      },
      build: () => addContactsCubit,
      act: (cubit) => cubit.searchProfiles('Unknown'),
      expect: () => [
        const AddContactsLoading(),
        const AddContactsLoaded([]),
      ],
      verify: (_) {
        // Verify that the searchProfiles method was called once
        verify(() => mockChatRepository.searchProfiles('Unknown')).called(1);
      },
    );
  });
}
