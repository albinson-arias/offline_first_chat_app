import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

import 'package:offline_first_chat_app/features/profile/presentation/cubit/pick_profile_pic_cubit/pick_profile_pic_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/pick_picture_source_dialog_option.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';

class PickPictureSourceDialog extends StatelessWidget {
  const PickPictureSourceDialog({
    required this.cubit,
    super.key,
  });
  final PickProfilePicCubit cubit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(12).copyWith(top: 0),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  PickPictureSourceDialogOption(
                    onTap: () {
                      context.pop();
                      cubit.pickProfilePicFromSource(ImageSource.gallery);
                    },
                    icon: HugeIcons.strokeRoundedFolderLibrary,
                    title: 'Pick From Gallery',
                  ),
                  const Divider(),
                  PickPictureSourceDialogOption(
                    onTap: () {
                      context.pop();
                      cubit.pickProfilePicFromSource(ImageSource.camera);
                    },
                    icon: HugeIcons.strokeRoundedCamera01,
                    title: 'Pick From Camera',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kBottomNavigationBarHeight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Cancel',
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
