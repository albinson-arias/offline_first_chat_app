import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';

part 'add_contacts_state.dart';

class AddContactsCubit extends Cubit<AddContactsState> {
  AddContactsCubit({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const AddContactsLoaded([]));

  final ChatRepository _chatRepository;

  Future<void> searchProfiles(String query) async {
    emit(const AddContactsLoading());

    final result = await _chatRepository.searchProfiles(query);

    emit(AddContactsLoaded(result));
  }
}
