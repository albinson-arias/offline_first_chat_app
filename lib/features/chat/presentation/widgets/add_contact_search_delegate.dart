import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/add_contacts_cubit/add_contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/contacts_list.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/core/utils/debouncer.dart';

class AddContactsSearchDelegate extends SearchDelegate<Profile?> {
  AddContactsSearchDelegate({
    required this.contactsCubit,
    Debouncer? debouncer,
  }) {
    cubit = sl();
    _debouncer = debouncer ?? Debouncer(milliseconds: 500);
  }
  final ContactsCubit contactsCubit;

  late final AddContactsCubit cubit;
  late final Debouncer _debouncer;

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query.isEmpty ? close(context, null) : query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildSuggestions(BuildContext context) {
    _debouncer.run(
      () {
        cubit.searchProfiles(query);
      },
    );

    return BlocBuilder<AddContactsCubit, AddContactsState>(
      bloc: cubit,
      builder: (context, state) {
        return switch (state) {
          (AddContactsLoaded(:final contacts)) => contacts.isEmpty
              ? const Center(
                  child: Text('No Results', style: TextStyle(fontSize: 24)),
                )
              : BlocProvider.value(
                  value: contactsCubit,
                  child: ContactsList(
                    contacts: contacts,
                  ),
                ),
          _ => const Center(child: CircularProgressIndicator.adaptive())
        };
      },
    );
  }
}
