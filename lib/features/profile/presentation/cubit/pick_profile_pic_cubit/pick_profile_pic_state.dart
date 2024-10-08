part of 'pick_profile_pic_cubit.dart';

sealed class PickProfilePicState {
  const PickProfilePicState();
}

final class PickProfilePicInitial extends PickProfilePicState {
  const PickProfilePicInitial();
}

final class PickProfilePicLoading extends PickProfilePicState {
  const PickProfilePicLoading();
}

final class PickProfilePicFailure extends PickProfilePicState {
  const PickProfilePicFailure(this.failure);
  final Failure failure;
}

final class PickProfilePicLoaded extends PickProfilePicState {
  const PickProfilePicLoaded(this.message);
  final String message;
}
