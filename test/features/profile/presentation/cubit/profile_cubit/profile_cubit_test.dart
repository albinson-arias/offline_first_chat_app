import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:record_result/record_result.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProfileCubit cubit;
  late MockAuthRepository mockAuthRepository;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockProfileRepository = MockProfileRepository();
  });

  group('loadData', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when loadData '
      'is called and stream provides a profile',
      build: () {
        final profile = Profile(
          id: '123',
          createdAt: DateTime(2002, 06, 11),
          username: 'test_user',
          bio: 'This is a test bio',
        );

        when(() => mockAuthRepository.getCurrentUserStream())
            .thenAnswer((_) => Stream.value(profile));

        return ProfileCubit(
          repository: mockAuthRepository,
          profileRepository: mockProfileRepository,
        );
      },
      expect: () => [
        ProfileLoaded(
          Profile(
            id: '123',
            createdAt: DateTime(2002, 06, 11),
            username: 'test_user',
            bio: 'This is a test bio',
          ),
        ),
      ],
    );
  });

  group('close', () {
    test('cancels the subscription on close', () async {
      final stream = StreamController<Profile>();

      when(() => mockAuthRepository.getCurrentUserStream()).thenAnswer(
        (_) => stream.stream,
      );

      cubit = ProfileCubit(
        repository: mockAuthRepository,
        profileRepository: mockProfileRepository,
      );

      await cubit.close();

      expect(cubit.isClosed, true);
    });
  });

  group('editBio', () {
    blocTest<ProfileCubit, ProfileState>(
      'calls updateBio in ProfileRepository when editBio is invoked',
      build: () {
        when(() => mockAuthRepository.getCurrentUserStream())
            .thenAnswer((_) => const Stream.empty());

        when(() => mockProfileRepository.updateBio(any()))
            .thenAnswer((_) async => right(null));

        return ProfileCubit(
          repository: mockAuthRepository,
          profileRepository: mockProfileRepository,
        );
      },
      act: (cubit) async {
        await cubit.editBio('Updated bio');
      },
      verify: (_) {
        verify(() => mockProfileRepository.updateBio('Updated bio')).called(1);
      },
    );
  });
}
