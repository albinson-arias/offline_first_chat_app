import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/widgets.dart';
import 'package:offline_first_chat_app/src/common/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
  });

  void showNewChatDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const NewChatDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, int>(
      bloc: sl(),
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (state == 0) return;
                            context.goNamed(AppRoutes.rooms.name);
                            sl<BottomNavBarCubit>().navigateToHome();
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedHome01,
                              color: state == 0 ? Colors.blue : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () =>
                              context.pushNamed(AppRoutes.contacts.name),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  'New Chat',
                                  style: context.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (state == 1) return;
                            context.goNamed(AppRoutes.profile.name);
                            sl<BottomNavBarCubit>().navigateToProfile();
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedUser,
                              color: state == 1 ? Colors.blue : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
