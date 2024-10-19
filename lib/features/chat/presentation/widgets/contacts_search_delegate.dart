import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/contacts_list.dart';

class ContactsSearchDelegate extends SearchDelegate<Profile?> {
  ContactsSearchDelegate(this.profiles, this.cubit);

  final ContactsCubit cubit;

  final List<Profile> profiles;
  List<Profile> results = <Profile>[];

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
    results = profiles.where((Profile profile) {
      final title = profile.username.toLowerCase();
      final input = query.toLowerCase();

      return title.contains(input);
    }).toList();

    return results.isEmpty
        ? const Center(
            child: Text('No Results', style: TextStyle(fontSize: 24)),
          )
        : BlocProvider.value(
            value: cubit,
            child: ContactsList(contacts: results),
          );
  }
}
