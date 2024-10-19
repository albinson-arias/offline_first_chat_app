part of 'contacts_cubit.dart';

sealed class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [contacts];
}

final class ContactsNavigateToRoom extends ContactsState {
  const ContactsNavigateToRoom(this.room);

  final Room room;

  @override
  List<Object?> get props => [room];
}
