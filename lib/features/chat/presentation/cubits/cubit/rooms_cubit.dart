import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const RoomsInitial()) {
    loadRooms();
  }

  final ChatRepository _chatRepository;
  StreamSubscription<List<Room>>? subscription;

  @override
  Future<void> close() async {
    await subscription?.cancel();
    return super.close();
  }

  Future<void> loadRooms() async {
    emit(const RoomsLoading());

    subscription = _chatRepository.getRooms().listen(
      (event) {
        emit(RoomsLoaded(event));
      },
    );
  }
}
