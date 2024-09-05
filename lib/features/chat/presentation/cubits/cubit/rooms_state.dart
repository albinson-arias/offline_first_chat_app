part of 'rooms_cubit.dart';

sealed class RoomsState {
  const RoomsState();
}

final class RoomsInitial extends RoomsState {
  const RoomsInitial();
}

final class RoomsLoading extends RoomsState {
  const RoomsLoading();
}

final class RoomsLoaded extends RoomsState {
  const RoomsLoaded(this.rooms);

  final List<Room> rooms;
}
