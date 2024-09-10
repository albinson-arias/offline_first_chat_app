import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const ChatInitial());

  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatMessage>>? subscription;

  @override
  Future<void> close() async {
    await subscription?.cancel();
    return super.close();
  }

  Future<void> loadChat(String roomId) async {
    emit(const ChatLoading());

    subscription = _chatRepository.getMessagesForRoom(roomId).listen(
      (event) {
        emit(ChatLoaded(event));
      },
    );
  }

  Future<void> sendMessage(String roomId, String content) async {
    await _chatRepository.sendMessage(roomId, content);
  }
}
