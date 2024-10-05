import 'package:cross_file/cross_file.dart';
import 'package:offline_first_chat_app/src/common/domain/repositories/image_uploader.dart';
import 'package:offline_first_chat_app/src/database/storage_constants.dart';
import 'package:record_result/record_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploaderImpl implements ImageUploader {
  ImageUploaderImpl({required SupabaseStorageClient storageClient})
      : _storageClient = storageClient;

  final SupabaseStorageClient _storageClient;

  @override
  FutureResult<String> uploadImage(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await _storageClient
          .from(StorageConstants.profilePicsBucket)
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: 'image/$fileExt'),
          );
      final imageUrlResponse = await _storageClient
          .from(StorageConstants.profilePicsBucket)
          .createSignedUrl(
            filePath,
            60 * 60 * 24 * 365 * 10,
          );

      return right(imageUrlResponse);
    } on StorageException catch (error) {
      return left(
        ServerFailure(message: error.message, statusCode: error.statusCode),
      );
    } catch (error) {
      return left(
        ServerFailure(message: 'Unexpected error occurred', statusCode: 505),
      );
    }
  }
}
