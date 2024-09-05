// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'story.dart';

class StoryMapper extends ClassMapperBase<Story> {
  StoryMapper._();

  static StoryMapper? _instance;
  static StoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StoryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Story';

  static String _$name(Story v) => v.name;
  static const Field<Story, String> _f$name = Field('name', _$name);
  static String _$imageUrl(Story v) => v.imageUrl;
  static const Field<Story, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl, key: 'image_url');

  @override
  final MappableFields<Story> fields = const {
    #name: _f$name,
    #imageUrl: _f$imageUrl,
  };

  static Story _instantiate(DecodingData data) {
    return Story(name: data.dec(_f$name), imageUrl: data.dec(_f$imageUrl));
  }

  @override
  final Function instantiate = _instantiate;

  static Story fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Story>(map);
  }

  static Story fromJson(String json) {
    return ensureInitialized().decodeJson<Story>(json);
  }
}

mixin StoryMappable {
  String toJson() {
    return StoryMapper.ensureInitialized().encodeJson<Story>(this as Story);
  }

  Map<String, dynamic> toMap() {
    return StoryMapper.ensureInitialized().encodeMap<Story>(this as Story);
  }

  StoryCopyWith<Story, Story, Story> get copyWith =>
      _StoryCopyWithImpl(this as Story, $identity, $identity);
  @override
  String toString() {
    return StoryMapper.ensureInitialized().stringifyValue(this as Story);
  }

  @override
  bool operator ==(Object other) {
    return StoryMapper.ensureInitialized().equalsValue(this as Story, other);
  }

  @override
  int get hashCode {
    return StoryMapper.ensureInitialized().hashValue(this as Story);
  }
}

extension StoryValueCopy<$R, $Out> on ObjectCopyWith<$R, Story, $Out> {
  StoryCopyWith<$R, Story, $Out> get $asStory =>
      $base.as((v, t, t2) => _StoryCopyWithImpl(v, t, t2));
}

abstract class StoryCopyWith<$R, $In extends Story, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? imageUrl});
  StoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StoryCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Story, $Out>
    implements StoryCopyWith<$R, Story, $Out> {
  _StoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Story> $mapper = StoryMapper.ensureInitialized();
  @override
  $R call({String? name, String? imageUrl}) => $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (imageUrl != null) #imageUrl: imageUrl
      }));
  @override
  Story $make(CopyWithData data) => Story(
      name: data.get(#name, or: $value.name),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl));

  @override
  StoryCopyWith<$R2, Story, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _StoryCopyWithImpl($value, $cast, t);
}
