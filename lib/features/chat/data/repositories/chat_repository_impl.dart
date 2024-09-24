import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/local/chat_local_datasource.dart';
import 'package:offline_first_chat_app/features/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/chat_message.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required ChatLocalDatasource localDatasource,
    required ChatRemoteDatasource remoteDatasource,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource;

  final ChatLocalDatasource _localDatasource;
  final ChatRemoteDatasource _remoteDatasource;

  @override
  Future<List<Profile>> getContacts() => _localDatasource.getContacts();

  @override
  Stream<List<ChatMessage>> getMessagesForRoom(String id) =>
      _localDatasource.getMessagesForRoom(id);

  @override
  Stream<List<Room>> getRooms() => _localDatasource.getRooms();

  @override
  Future<List<Profile>> searchProfiles(String search) =>
      _remoteDatasource.searchProfiles(search);

  @override
  Future<void> sendMessage(String roomId, String content) =>
      _localDatasource.sendMessage(roomId, content);

  @override
  Future<Room?> getRoomWithParticipant(String id) =>
      _localDatasource.getRoomWithParticipant(id);

  @override
  Future<Room> startConversation(Profile profile) async {
    await _remoteDatasource.createProfileInteractions(profile.id);
    return _localDatasource.startConversation(profile);
  }
}
