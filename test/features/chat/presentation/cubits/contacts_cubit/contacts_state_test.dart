import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';

void main() {
  group('ContactsState Tests', () {
    final profile = Profile(
      id: '1',
      username: 'John Doe',
      imageUrl: 'image1.png',
      bio: '',
      createdAt: DateTime(2002, 06, 11),
    );
    final otherProfile = Profile(
      id: '2',
      username: 'Albinson Arias',
      imageUrl: 'image1.png',
      bio: '',
      createdAt: DateTime(2002, 06, 11),
    );

    test('ContactsInitial can be instantiated', () {
      const state = ContactsInitial();
      expect(state, isA<ContactsInitial>());
    });

    test('ContactsLoading can be instantiated', () {
      const state = ContactsLoading();
      expect(state, isA<ContactsLoading>());
    });

    test('ContactsLoaded can be instantiated with a list of contacts', () {
      final contacts = [
        profile,
        otherProfile,
      ];
      final state = ContactsLoaded(contacts);

      expect(state.contacts, contacts);
      expect(state.contacts.length, 2);
    });

    test('ContactsLoaded props returns correct values', () {
      final contacts = [
        profile,
      ];
      final state = ContactsLoaded(contacts);

      expect(state.props, [contacts]);
    });

    test('ContactsNavigateToRoom can be instantiated with a room', () {
      final room = Room(
        id: 'room1',
        createdAt: DateTime(2002, 06, 11),
        participants: [
          profile,
        ],
        unreadMessages: 0,
      );
      final state = ContactsNavigateToRoom(room);

      expect(state.room, room);
    });

    test('ContactsNavigateToRoom props returns correct values', () {
      final room = Room(
        id: 'room1',
        createdAt: DateTime(2002, 06, 11),
        participants: [
          profile,
        ],
        unreadMessages: 0,
      );
      final state = ContactsNavigateToRoom(room);

      expect(state.props, [room]);
    });

    test('ContactsState equality works correctly', () {
      final contacts = [
        profile,
      ];
      final state1 = ContactsLoaded(contacts);
      final state2 = ContactsLoaded(contacts);

      expect(state1, equals(state2));

      const initial1 = ContactsInitial();
      const initial2 = ContactsInitial();
      expect(initial1, equals(initial2));

      const loading1 = ContactsLoading();
      const loading2 = ContactsLoading();
      expect(loading1, equals(loading2));

      final room = Room(
        id: 'room1',
        createdAt: DateTime(2002, 06, 11),
        participants: [
          profile,
        ],
        unreadMessages: 0,
      );
      final state3 = ContactsNavigateToRoom(room);
      final state4 = ContactsNavigateToRoom(room);

      expect(state3, equals(state4));
    });
  });
}
