import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/pick_profile_pic_cubit/pick_profile_pic_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/pick_picture_source_dialog.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/common/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';
import 'package:offline_first_chat_app/src/core/utils/core_utils.dart';
import 'package:offline_first_chat_app/src/gen/assets.gen.dart';
import 'package:offline_first_chat_app/src/notifications/notification_controller.dart';

class ProfileScreenLoaded extends StatelessWidget {
  const ProfileScreenLoaded({
    required this.profile,
    super.key,
  });
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PickProfilePicCubit, PickProfilePicState>(
      listenWhen: (previous, current) {
        if (previous is PickProfilePicLoading) {
          context.pop();
        }
        return true;
      },
      listener: (context, state) {
        if (state is PickProfilePicLoading) {
          CoreUtils.showLoadingDialog(context);
        } else if (state is PickProfilePicFailure) {
          CoreUtils.showSnackBar(context, state.failure.errorMessage);
        } else if (state is PickProfilePicLoaded) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: profile.imageUrl == null
                        ? Assets.icons.profile.svg(
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: profile.imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: Colors.blue,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        final cubit = context.read<PickProfilePicCubit>();
                        showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return PickPictureSourceDialog(
                              cubit: cubit,
                              hasProfilePic: profile.imageUrl != null,
                            );
                          },
                        );
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                profile.username,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                'Bio',
                style: context.textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => context.pushNamed(AppRoutes.bio.name),
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
            // const SizedBox(height: 8),
            // Center(
            //   child: PrimaryButton(
            //     title: 'Edit Profile',
            //     onTap: () {},
            //   ),
            // ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                'Preferences',
                style: context.textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 12,
                      top: 2,
                      bottom: 2,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Notifications',
                          style: context.textTheme.labelLarge,
                        ),
                        const Spacer(),
                        Checkbox(
                          value: profile.fcmToken != null,
                          shape: const CircleBorder(),
                          fillColor: WidgetStatePropertyAll(
                            profile.fcmToken != null
                                ? Colors.blue
                                : const Color(0xFFF1F1F1),
                          ),
                          onChanged: (value) {
                            if (value!) {
                              sl<GlobalStore>().userDeniedNotifications = false;
                              sl<NotificationController>().requestPermissions(
                                goToSettingsIfDenied: true,
                              );
                            } else {
                              sl<NotificationController>()
                                  .disableNotifications();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        sl<AuthRepository>().signOut();
                        sl<BottomNavBarCubit>().navigateToHome();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.red.shade900,
                        elevation: 0,
                        overlayColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 12),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
