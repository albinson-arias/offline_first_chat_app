import 'dart:async';

import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/image_uploader_impl.dart';
import 'package:offline_first_chat_app/src/database/storage_constants.dart';
import 'package:record_result/record_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock classes
class MockSupabaseStorageClient extends Mock implements SupabaseStorageClient {}

class MockXFile extends Mock implements XFile {}

class MockStorageFileApi extends Mock implements StorageFileApi {}

void main() {
  late ImageUploaderImpl imageUploader;
  late MockSupabaseStorageClient mockSupabaseStorageClient;
  late MockXFile mockXFile;
  late MockStorageFileApi mockStorageFileApi;

  setUpAll(() {
    registerFallbackValue(Uint8List(4));
    registerFallbackValue(const FileOptions());
  });

  setUp(() {
    mockSupabaseStorageClient = MockSupabaseStorageClient();
    mockXFile = MockXFile();
    mockStorageFileApi = MockStorageFileApi();
    imageUploader = ImageUploaderImpl(storageClient: mockSupabaseStorageClient);
  });

  group('ImageUploaderImpl', () {
    const bucket = StorageConstants.profilePicsBucket;
    const filePath = 'some_image_path.jpg';
    const imageUrl = 'https://somebucketurl.com/some_image_path.jpg';
    final bytes = Uint8List(4); // Some image byte data

    test('should upload image and return the signed URL on success', () async {
      // Arrange

      when(() => mockXFile.readAsBytes())
          .thenAnswer((_) => Future.value(bytes));
      when(() => mockXFile.path).thenReturn(filePath);
      when(
        () => mockSupabaseStorageClient.from(bucket),
      ).thenReturn(mockStorageFileApi);

      when(
        () => mockStorageFileApi.uploadBinary(
          any(),
          any(),
          fileOptions: any(named: 'fileOptions'),
        ),
      ).thenAnswer((_) => Future.value('a'));

      when(
        () => mockStorageFileApi.createSignedUrl(any(), any()),
      ).thenAnswer((_) async => imageUrl);

      // Act
      final result = await imageUploader.uploadImage(mockXFile);

      // Assert
      expect(result.isSuccess, true);
      expect(result.success, imageUrl);
      verify(() => mockXFile.readAsBytes()).called(1);
      verify(
        () => mockStorageFileApi.uploadBinary(
          any(),
          any(),
          fileOptions: any(named: 'fileOptions'),
        ),
      ).called(1);
      verify(
        () => mockStorageFileApi.createSignedUrl(any(), any()),
      ).called(1);
    });

    test('should return ServerFailure when StorageException occurs', () async {
      // Arrange
      when(() => mockXFile.readAsBytes())
          .thenAnswer((_) => Future.value(bytes as FutureOr<Uint8List>?));
      when(() => mockXFile.path).thenReturn(filePath);
      when(
        () => mockSupabaseStorageClient.from(bucket),
      ).thenReturn(mockStorageFileApi);

      when(
        () => mockStorageFileApi.uploadBinary(
          any(),
          any(),
          fileOptions: any(named: 'fileOptions'),
        ),
      ).thenThrow(
        const StorageException('Upload failed', statusCode: '500'),
      );

      // Act
      final result = await imageUploader.uploadImage(mockXFile);

      // Assert
      expect(result.isFailure, true);
      result.fold(
        (_) => fail('Expected a failure'),
        (failure) {
          expect(failure.message, 'Upload failed');
          expect(failure.statusCode, '500');
        },
      );
      verify(() => mockXFile.readAsBytes()).called(1);
      verify(
        () => mockSupabaseStorageClient
            .from(bucket)
            .uploadBinary(any(), any(), fileOptions: any(named: 'fileOptions')),
      ).called(1);
    });

    test('should return ServerFailure when unexpected error occurs', () async {
      // Arrange
      when(() => mockXFile.readAsBytes())
          .thenAnswer((_) => Future.value(bytes as FutureOr<Uint8List>?));
      when(() => mockXFile.path).thenReturn(filePath);
      when(
        () => mockSupabaseStorageClient.from(bucket),
      ).thenReturn(mockStorageFileApi);

      when(
        () => mockStorageFileApi.uploadBinary(
          any(),
          any(),
          fileOptions: any(named: 'fileOptions'),
        ),
      ).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await imageUploader.uploadImage(mockXFile);

      // Assert
      expect(result.isFailure, true);
      result.fold(
        (_) => fail('Expected a failure'),
        (failure) {
          expect(failure.message, 'Unexpected error occurred');
          expect(failure.statusCode, '505');
        },
      );
      verify(() => mockXFile.readAsBytes()).called(1);
      verify(
        () => mockSupabaseStorageClient
            .from(bucket)
            .uploadBinary(any(), any(), fileOptions: any(named: 'fileOptions')),
      ).called(1);
    });
  });
}
