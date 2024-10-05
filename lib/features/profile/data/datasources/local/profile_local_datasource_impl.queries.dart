part of 'profile_local_datasource_impl.dart';

const updateProfilePicSQLQuery = '''
UPDATE profiles
SET image_url = ?
WHERE id = ? ;
''';
