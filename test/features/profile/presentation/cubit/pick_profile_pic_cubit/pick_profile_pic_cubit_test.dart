import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/pick_profile_pic_cubit/pick_profile_pic_cubit.dart';
import 'package:record_result/record_result.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  late PickProfilePicCubit cubit;
  late MockProfileRepository mockProfileRepository;
  late MockImagePicker mockImagePicker;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    mockImagePicker = MockImagePicker();
    cubit = PickProfilePicCubit(
      repository: mockProfileRepository,
      imagePicker: mockImagePicker,
    );
  });

  setUpAll(() {
    registerFallbackValue(ImageSource.camera);
  });

  group('PickProfilePicCubit ImagePicker initialization', () {
    test('uses the provided ImagePicker when injected', () {
      cubit = PickProfilePicCubit(
        repository: mockProfileRepository,
        imagePicker: mockImagePicker, // Custom ImagePicker provided
      );

      expect(cubit.imagePicker, equals(mockImagePicker));
    });

    test('uses default ImagePicker when none is provided', () {
      cubit = PickProfilePicCubit(
        repository: mockProfileRepository,
      );

      // Since default ImagePicker is created, we just check the type
      expect(cubit.imagePicker, isA<ImagePicker>());
    });
  });
  group('PickProfilePicCubit', () {
    blocTest<PickProfilePicCubit, PickProfilePicState>(
      'emits [PickProfilePicLoading, PickProfilePicInitial] '
      'when no image is picked',
      build: () {
        when(() => mockImagePicker.pickImage(source: any(named: 'source')))
            .thenAnswer((_) async => null); // No image selected
        return cubit;
      },
      act: (cubit) => cubit.pickProfilePicFromSource(ImageSource.gallery),
      expect: () => [
        const PickProfilePicLoading(),
        const PickProfilePicInitial(),
      ],
    );

    blocTest<PickProfilePicCubit, PickProfilePicState>(
      'emits [PickProfilePicLoading, PickProfilePicLoaded] '
      'when image upload is successful',
      build: () {
        final imagePickerResult = XFile('path/to/image.jpg');
        when(() => mockImagePicker.pickImage(source: any(named: 'source')))
            .thenAnswer((_) async => imagePickerResult);

        when(
          () => mockProfileRepository.uploadProfilePicture(imagePickerResult),
        ).thenAnswer(
          (_) async => right(null),
        );

        return cubit;
      },
      act: (cubit) => cubit.pickProfilePicFromSource(ImageSource.camera),
      expect: () => [
        const PickProfilePicLoading(),
        const PickProfilePicLoaded('Image uploaded successfully'),
      ],
    );

    blocTest<PickProfilePicCubit, PickProfilePicState>(
      'emits [PickProfilePicLoading, PickProfilePicFailure] '
      'when image upload fails',
      build: () {
        final imagePickerResult = XFile('path/to/image.jpg');
        when(() => mockImagePicker.pickImage(source: any(named: 'source')))
            .thenAnswer((_) async => imagePickerResult);

        when(
          () => mockProfileRepository.uploadProfilePicture(imagePickerResult),
        ).thenAnswer(
          (_) async =>
              left(ServerFailure(message: 'Upload failed', statusCode: 500)),
        );

        return cubit;
      },
      act: (cubit) => cubit.pickProfilePicFromSource(ImageSource.camera),
      expect: () => [
        const PickProfilePicLoading(),
        PickProfilePicFailure(
          ServerFailure(message: 'Upload failed', statusCode: 500),
        ),
      ],
    );

    blocTest<PickProfilePicCubit, PickProfilePicState>(
      'emits [PickProfilePicLoading, PickProfilePicLoaded]'
      ' when profile pic is deleted successfully',
      build: () {
        when(() => mockProfileRepository.deleteProfilePicture())
            .thenAnswer((_) async => right(null));

        return cubit;
      },
      act: (cubit) => cubit.deleteProfilePic(),
      expect: () => [
        const PickProfilePicLoading(),
        const PickProfilePicLoaded('Image deleted successfully'),
      ],
    );

    blocTest<PickProfilePicCubit, PickProfilePicState>(
      'emits [PickProfilePicLoading, PickProfilePicFailure]'
      ' when profile pic deletion fails',
      build: () {
        when(() => mockProfileRepository.deleteProfilePicture()).thenAnswer(
          (_) async =>
              left(ServerFailure(message: 'Upload failed', statusCode: 500)),
        );

        return cubit;
      },
      act: (cubit) => cubit.deleteProfilePic(),
      expect: () => [
        const PickProfilePicLoading(),
        PickProfilePicFailure(
          ServerFailure(message: 'Upload failed', statusCode: 500),
        ),
      ],
    );
  });
}
