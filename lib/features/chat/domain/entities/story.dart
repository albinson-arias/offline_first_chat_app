import 'package:dart_mappable/dart_mappable.dart';
import 'package:offline_first_chat_app/src/gen/assets.gen.dart';

part 'story.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class Story with StoryMappable {
  const Story({
    required this.name,
    required this.imageUrl,
  });
  final String name;
  final String imageUrl;

  static List<Story> get stories => [
        Story(
          name: 'Marta',
          imageUrl: Assets.profilePics.a1.path,
        ),
        Story(
          name: 'Jennifer',
          imageUrl: Assets.profilePics.a2.path,
        ),
      ];
}
