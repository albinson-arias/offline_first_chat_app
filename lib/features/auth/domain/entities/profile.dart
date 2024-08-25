import 'package:dart_mappable/dart_mappable.dart';

part 'profile.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Profile with ProfileMappable {
  const Profile({
    required this.id,
    required this.createdAt,
    required this.username,
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
}
