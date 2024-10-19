import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/add_contacts_cubit/add_contacts_cubit.dart';

void main() {
  group('AddContactsState Tests', () {
    final profile = Profile(
      id: '1',
      username: 'John Doe',
      imageUrl: 'image1.png',
      bio: '',
      createdAt: DateTime(2002, 06, 11),
    );
    final contacts = [
      profile,
      Profile(
        id: '2',
        username: 'Jane Doe',
        imageUrl: 'image2.png',
        bio: '',
        createdAt: DateTime(2002, 06, 11),
      ),
    ];
    test('AddContactsInitial can be instantiated', () {
      const state = AddContactsInitial();
      expect(state, isA<AddContactsInitial>());
    });

    test('AddContactsLoading can be instantiated', () {
      const state = AddContactsLoading();
      expect(state, isA<AddContactsLoading>());
    });

    test('AddContactsLoaded can be instantiated with contacts', () {
      final state = AddContactsLoaded(contacts);

      expect(state.contacts, contacts);
      expect(state.contacts.length, 2);
      expect(state.contacts.first.username, 'John Doe');
    });

    test('AddContactsNavigateToRoom can be instantiated with room', () {
      final room = Room(
        id: 'room1',
        createdAt: DateTime.now(),
        participants: [
          Profile(
            id: '1',
            username: 'John Doe',
            imageUrl: 'image1.png',
            bio: '',
            createdAt: DateTime(2002, 06, 11),
          ),
        ],
        unreadMessages: 0,
      );
      final state = AddContactsNavigateToRoom(room);

      expect(state.room, room);
      expect(state.room.id, 'room1');
      expect(state.room.participants.length, 1);
    });

    test('AddContactsState equality works correctly', () {
      final state1 = AddContactsLoaded(contacts);
      final state2 = AddContactsLoaded(contacts);

      expect(state1, equals(state2));

      final room = Room(
        id: 'room1',
        createdAt: DateTime.now(),
        participants: [
          profile,
        ],
        unreadMessages: 0,
      );
      final state3 = AddContactsNavigateToRoom(room);
      final state4 = AddContactsNavigateToRoom(room);

      expect(state3, equals(state4));
    });
  });
}
