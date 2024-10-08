import 'package:dart_mappable/dart_mappable.dart';

part 'profile.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Profile with ProfileMappable {
  const Profile({
    required this.id,
    required this.createdAt,
    required this.username,
    required this.bio,
    this.imageUrl,
  });

  /// The unique identifier of the user.
  final String id;

  /// The date and time when the user was created.
  final DateTime createdAt;

  /// The name of the user.
  final String username;

  /// The optional URL of the user's avatar image.
  final String? imageUrl;

  /// A short description of this user.
  /// Maximum length is 100.
  final String bio;
}
