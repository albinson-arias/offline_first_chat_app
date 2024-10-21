import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';

void main() {
  group('ProfileInitial', () {
    test('supports equality and has empty props', () {
      const state = ProfileInitial();
      expect(state, const ProfileInitial());
      expect(state.props, <Object?>[]);
    });
  });

  group('ProfileLoading', () {
    test('supports equality and has empty props', () {
      const state = ProfileLoading();
      expect(state, const ProfileLoading());
      expect(state.props, <Object?>[]);
    });
  });

  group('ProfileLoaded', () {
    test('supports equality with the same profile', () {
      final profile = Profile(
        id: '123',
        createdAt: DateTime(2023, 10, 17),
        username: 'test_user',
        bio: 'Test bio',
      );

      final state = ProfileLoaded(profile);
      expect(
        state,
        ProfileLoaded(profile),
      ); // Same profile, should be equal
    });

    test('does not support equality with different profiles', () {
      final profile1 = Profile(
        id: '123',
        createdAt: DateTime(2023, 10, 17),
        username: 'test_user',
        bio: 'Test bio',
      );

      final profile2 = Profile(
        id: '456',
        createdAt: DateTime(2023, 10, 18),
        username: 'another_user',
        bio: 'Another bio',
      );

      final state1 = ProfileLoaded(profile1);
      final state2 = ProfileLoaded(profile2);

      expect(state1, isNot(state2)); // Different profiles, should not be equal
    });

    test('has correct props with the profile', () {
      final profile = Profile(
        id: '123',
        createdAt: DateTime(2023, 10, 17),
        username: 'test_user',
        bio: 'Test bio',
      );

      final state = ProfileLoaded(profile);
      expect(state.props, [profile]); // Props should include the profile
    });
  });
}
