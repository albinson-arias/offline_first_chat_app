import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_first_chat_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:record_result/record_result.dart';

part 'pick_profile_pic_state.dart';

class PickProfilePicCubit extends Cubit<PickProfilePicState> {
  PickProfilePicCubit({required ProfileRepository repository})
      : _profileRepository = repository,
        super(const PickProfilePicInitial());

  final ImagePicker _imagePicker = ImagePicker();
  final ProfileRepository _profileRepository;

  Future<void> pickProfilePicFromSource(ImageSource source) async {
    emit(const PickProfilePicLoading());
    final imagePickerResult = await _imagePicker.pickImage(source: source);

    if (imagePickerResult == null) emit(const PickProfilePicInitial());

    final result =
        await _profileRepository.uploadProfilePicture(imagePickerResult!);

    result.fold(
      (success) => emit(
        const PickProfilePicLoaded(
          'Image uploaded successfully',
        ),
      ),
      (failure) => emit(PickProfilePicFailure(failure)),
    );
  }

  Future<void> deleteProfilePic() async {
    emit(const PickProfilePicLoading());

    final result = await _profileRepository.deleteProfilePicture();

    result.fold(
      (success) => emit(
        const PickProfilePicLoaded(
          'Image deleted successfully',
        ),
      ),
      (failure) => emit(PickProfilePicFailure(failure)),
    );
  }
}
