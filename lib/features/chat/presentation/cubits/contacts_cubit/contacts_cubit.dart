import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const ContactsInitial()) {
    loadContacts();
  }

  final ChatRepository _chatRepository;

  Future<void> loadContacts() async {
    emit(const ContactsLoading());

    final result = await _chatRepository.getContacts();

    emit(ContactsLoaded(result));
  }

  Future<void> loadRoom(Profile profile) async {
    emit(const ContactsLoading());

    var result = await _chatRepository.getRoomWithParticipant(profile.id);

    result ??= await _chatRepository.startConversation(profile);

    emit(ContactsNavigateToRoom(result));
  }
}
