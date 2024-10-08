// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'profile.dart';

class ProfileMapper extends ClassMapperBase<Profile> {
  ProfileMapper._();

  static ProfileMapper? _instance;
  static ProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Profile';

  static String _$id(Profile v) => v.id;
  static const Field<Profile, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(Profile v) => v.createdAt;
  static const Field<Profile, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: 'created_at');
  static String _$username(Profile v) => v.username;
  static const Field<Profile, String> _f$username =
      Field('username', _$username);
  static String _$bio(Profile v) => v.bio;
  static const Field<Profile, String> _f$bio = Field('bio', _$bio);
  static String? _$imageUrl(Profile v) => v.imageUrl;
  static const Field<Profile, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl, key: 'image_url', opt: true);

  @override
  final MappableFields<Profile> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #username: _f$username,
    #bio: _f$bio,
    #imageUrl: _f$imageUrl,
  };

  static Profile _instantiate(DecodingData data) {
    return Profile(
        id: data.dec(_f$id),
        createdAt: data.dec(_f$createdAt),
        username: data.dec(_f$username),
        bio: data.dec(_f$bio),
        imageUrl: data.dec(_f$imageUrl));
  }

  @override
  final Function instantiate = _instantiate;

  static Profile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Profile>(map);
  }

  static Profile fromJson(String json) {
    return ensureInitialized().decodeJson<Profile>(json);
  }
}

mixin ProfileMappable {
  String toJson() {
    return ProfileMapper.ensureInitialized()
        .encodeJson<Profile>(this as Profile);
  }

  Map<String, dynamic> toMap() {
    return ProfileMapper.ensureInitialized()
        .encodeMap<Profile>(this as Profile);
  }

  ProfileCopyWith<Profile, Profile, Profile> get copyWith =>
      _ProfileCopyWithImpl(this as Profile, $identity, $identity);
  @override
  String toString() {
    return ProfileMapper.ensureInitialized().stringifyValue(this as Profile);
  }

  @override
  bool operator ==(Object other) {
    return ProfileMapper.ensureInitialized()
        .equalsValue(this as Profile, other);
  }

  @override
  int get hashCode {
    return ProfileMapper.ensureInitialized().hashValue(this as Profile);
  }
}

extension ProfileValueCopy<$R, $Out> on ObjectCopyWith<$R, Profile, $Out> {
  ProfileCopyWith<$R, Profile, $Out> get $asProfile =>
      $base.as((v, t, t2) => _ProfileCopyWithImpl(v, t, t2));
}

abstract class ProfileCopyWith<$R, $In extends Profile, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      DateTime? createdAt,
      String? username,
      String? bio,
      String? imageUrl});
  ProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Profile, $Out>
    implements ProfileCopyWith<$R, Profile, $Out> {
  _ProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Profile> $mapper =
      ProfileMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          DateTime? createdAt,
          String? username,
          String? bio,
          Object? imageUrl = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (createdAt != null) #createdAt: createdAt,
        if (username != null) #username: username,
        if (bio != null) #bio: bio,
        if (imageUrl != $none) #imageUrl: imageUrl
      }));
  @override
  Profile $make(CopyWithData data) => Profile(
      id: data.get(#id, or: $value.id),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      username: data.get(#username, or: $value.username),
      bio: data.get(#bio, or: $value.bio),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl));

  @override
  ProfileCopyWith<$R2, Profile, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProfileCopyWithImpl($value, $cast, t);
}
