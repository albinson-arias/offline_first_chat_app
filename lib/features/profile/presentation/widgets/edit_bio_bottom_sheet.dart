import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';

class EditBioBottomSheet extends StatefulWidget {
  const EditBioBottomSheet({
    required this.bio,
    super.key,
  });

  final String bio;

  @override
  State<EditBioBottomSheet> createState() => _EditBioBottomSheetState();
}

class _EditBioBottomSheetState extends State<EditBioBottomSheet> {
  late String bio;

  @override
  void initState() {
    super.initState();
    bio = widget.bio;
  }

  Future<void> saveBio() async {
    await context.read<ProfileCubit>().editBio(bio);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: ColoredBox(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'Cancel',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      CupertinoButton(
                        onPressed: saveBio,
                        child: Text(
                          'Save',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      'Bio(${bio.length})',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  autofocus: true,
                  maxLines: null,
                  initialValue: bio,
                  onChanged: (value) {
                    setState(() {
                      bio = value;
                    });
                  },
                  onFieldSubmitted: (_) => saveBio(),
                  cursorColor: Colors.blue,
                  maxLength: 100,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
