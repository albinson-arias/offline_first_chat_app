import 'package:cross_file/cross_file.dart';
import 'package:offline_first_chat_app/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:offline_first_chat_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:offline_first_chat_app/src/common/domain/repositories/image_uploader.dart';
import 'package:offline_first_chat_app/src/core/errors/exceptions.dart';
import 'package:record_result/record_result.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ImageUploader imageUploader,
    required ProfileLocalDatasource localDatasource,
  })  : _imageUploader = imageUploader,
        _localDatasource = localDatasource;

  final ImageUploader _imageUploader;
  final ProfileLocalDatasource _localDatasource;

  @override
  FutureResultVoid uploadProfilePicture(XFile imageFile) async {
    try {
      final imageUrlResult = await _imageUploader.uploadImage(imageFile);
      if (imageUrlResult.isFailure) {
        return left(imageUrlResult.failure!);
      }

      await _localDatasource.updateProfilePicture(imageUrlResult.success);

      return voidSuccess;
    } on ServerException catch (e) {
      return left(e.toFailure());
    }
  }

  @override
  FutureResultVoid updateBio(String bio) async {
    try {
      await _localDatasource.updateBio(bio);

      return voidSuccess;
    } on ServerException catch (e) {
      return left(e.toFailure());
    }
  }

  @override
  FutureResultVoid deleteProfilePicture() async {
    try {
      await _localDatasource.updateProfilePicture(null);

      return voidSuccess;
    } on ServerException catch (e) {
      return left(e.toFailure());
    }
  }
}
