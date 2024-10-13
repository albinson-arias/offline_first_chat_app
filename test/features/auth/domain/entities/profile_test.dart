import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';

void main() {
  group('Profile Mappable Tests', () {
    test('should map Profile to JSON and back', () {
      // Arrange
      final profile = Profile(
        id: '123',
        createdAt: DateTime(2024, 10, 10).toUtc(),
        username: 'test_user',
        bio: 'This is a test user.',
        imageUrl: 'https://example.com/avatar.png',
        fcmToken: 'abc123fcm',
      );

      // Act
      final profileJson =
          profile.toMap(); // Convert the Profile instance to a map
      final newProfile = ProfileMapper.fromMap(
        profileJson,
      ); // Convert it back to a Profile object

      // Assert
      expect(newProfile.id, profile.id);
      expect(newProfile.createdAt, profile.createdAt);
      expect(newProfile.username, profile.username);
      expect(newProfile.bio, profile.bio);
      expect(newProfile.imageUrl, profile.imageUrl);
      expect(newProfile.fcmToken, profile.fcmToken);
    });

    test('should handle nullable fields correctly', () {
      // Arrange
      final profile = Profile(
        id: '123',
        createdAt: DateTime(2024, 10, 10),
        username: 'test_user',
        bio: 'This is a test user.',
      );

      // Act
      final profileJson = profile.toMap(); // Convert to map
      final newProfile = ProfileMapper.fromMap(profileJson); // Convert it back

      // Assert
      expect(newProfile.imageUrl, isNull);
      expect(newProfile.fcmToken, isNull);
    });
  });
}
