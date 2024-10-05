import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/profile_screen_loaded.dart';
import 'package:offline_first_chat_app/src/common/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:offline_first_chat_app/src/common/presentation/widgets/loading_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNavigationBar(),
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return switch (state) {
              (ProfileLoaded(:final profile)) => ProfileScreenLoaded(
                  profile: profile,
                ),
              _ => const LoadingView()
            };
          },
        ),
      ),
    );
  }
}
