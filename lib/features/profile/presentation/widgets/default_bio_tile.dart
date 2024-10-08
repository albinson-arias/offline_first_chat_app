import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';

class DefaultBioTile extends StatelessWidget {
  const DefaultBioTile({
    required this.bio,
    this.showDivider = true,
    this.selectedBio,
    super.key,
  });

  final String bio;
  final String? selectedBio;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (bio == selectedBio) return;
            context.read<ProfileCubit>().editBio(bio);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    bio,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (selectedBio == bio)
                  const Icon(
                    Icons.check,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(),
      ],
    );
  }
}
