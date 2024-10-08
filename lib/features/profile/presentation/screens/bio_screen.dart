import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_chat_app/features/profile/domain/entities/default_bios.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/default_bio_tile.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/edit_bio_bottom_sheet.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';

class BioScreen extends StatelessWidget {
  const BioScreen({super.key});

  void showEditBottomSheet(BuildContext context, String bio) {
    final cubit = context.read<ProfileCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: EditBioBottomSheet(
            bio: bio,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bio'),
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is! ProfileLoaded) {
              return const SizedBox.shrink();
            }
            final profile = state.profile;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Currently set to',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => showEditBottomSheet(context, profile.bio),
                  borderRadius: BorderRadius.circular(18),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              profile.bio,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Select your Bio',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  child: Column(
                    children: DefaultBios.values.indexed.map(
                      (e) {
                        return DefaultBioTile(
                          bio: e.$2.title,
                          selectedBio: profile.bio,
                          showDivider: e.$1 != DefaultBios.values.length - 1,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
