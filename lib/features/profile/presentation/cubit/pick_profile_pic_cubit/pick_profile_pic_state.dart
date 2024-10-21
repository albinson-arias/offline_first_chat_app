part of 'pick_profile_pic_cubit.dart';

sealed class PickProfilePicState extends Equatable {
  const PickProfilePicState();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [failure];
}

final class PickProfilePicLoaded extends PickProfilePicState {
  const PickProfilePicLoaded(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
