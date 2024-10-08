import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/features/profile/domain/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required AuthRepository repository,
    required ProfileRepository profileRepository,
  })  : _repository = repository,
        _profileRepository = profileRepository,
        super(const ProfileInitial()) {
    loadData();
  }

  final AuthRepository _repository;
  final ProfileRepository _profileRepository;
  StreamSubscription<Profile>? subscription;

  @override
  Future<void> close() async {
    await subscription?.cancel();
    return super.close();
  }

  void loadData() {
    emit(const ProfileLoading());

    subscription = _repository.getCurrentUserStream().listen(
      (event) {
        emit(ProfileLoaded(event));
      },
    );
  }

  Future<void> editBio(String bio) async {
    await _profileRepository.updateBio(bio);
  }
}
