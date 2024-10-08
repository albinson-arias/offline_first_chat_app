import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';
import 'package:offline_first_chat_app/src/core/utils/core_utils.dart';
import 'package:offline_first_chat_app/src/gen/assets.gen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({
    required this.contacts,
    super.key,
  });

  final List<Profile> contacts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 8),
                  child: Text(
                    'Contacts on OfflineFirstChatApp',
                    style: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ListTile(
                onTap: () {
                  CoreUtils.showLoadingDialog(context);

                  context.read<ContactsCubit>().loadRoom(contact);
                },
                leading: ClipOval(
                  child: contact.imageUrl == null
                      ? Assets.icons.profile.svg(
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: contact.imageUrl!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: Colors.blue,
                          ),
                        ),
                ),
                title: Text(
                  contact.username,
                  style: context.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
