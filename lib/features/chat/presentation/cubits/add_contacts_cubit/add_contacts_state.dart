part of 'add_contacts_cubit.dart';

sealed class AddContactsState {
  const AddContactsState();
}

final class AddContactsInitial extends AddContactsState {
  const AddContactsInitial();
}

final class AddContactsLoading extends AddContactsState {
  const AddContactsLoading();
}

final class AddContactsLoaded extends AddContactsState {
  const AddContactsLoaded(this.contacts);

  final List<Profile> contacts;
}

final class AddContactsNavigateToRoom extends AddContactsState {
  const AddContactsNavigateToRoom(this.room);

  final Room room;
}
