import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/add_contact_search_delegate.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/contacts_list.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/contacts_search_delegate.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactsCubit, ContactsState>(
      listener: (context, state) {
        if (state is ContactsNavigateToRoom) {
          context
            ..pop()
            ..pushReplacementNamed(
              AppRoutes.chat.name,
              pathParameters: {'roomId': state.room.id},
              extra: state.room,
            );
        }
      },
      listenWhen: (previous, current) => current is ContactsNavigateToRoom,
      buildWhen: (previous, current) {
        if (current is ContactsNavigateToRoom) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        return switch (state) {
          (ContactsLoaded(:final contacts)) => Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select contact',
                      style: context.textTheme.titleMedium,
                    ),
                    Text(
                      '${contacts.length} contacts',
                      style: context.textTheme.labelLarge,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => showSearch(
                      context: context,
                      delegate: ContactsSearchDelegate(
                        contacts,
                        context.read(),
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ListTile(
                      onTap: () => showSearch(
                        context: context,
                        delegate: AddContactsSearchDelegate(
                          contactsCubit: context.read(),
                        ),
                      ),
                      title: Text(
                        'Add Contacts',
                        style: context.textTheme.titleMedium,
                      ),
                      leading: const ClipOval(
                        child: ColoredBox(
                          color: Colors.blue,
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: ContactsList(contacts: contacts)),
                ],
              ),
            ),
          _ => const Scaffold(
              body: CircularProgressIndicator.adaptive(),
            )
        };
      },
    );
  }
}
