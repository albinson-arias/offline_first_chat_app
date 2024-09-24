part of 'contacts_cubit.dart';

sealed class ContactsState {
  const ContactsState();
}

final class ContactsInitial extends ContactsState {
  const ContactsInitial();
}

final class ContactsLoading extends ContactsState {
  const ContactsLoading();
}

final class ContactsLoaded extends ContactsState {
  const ContactsLoaded(this.contacts);

  final List<Profile> contacts;
}

final class ContactsNavigateToRoom extends ContactsState {
  const ContactsNavigateToRoom(this.room);

  final Room room;
}
