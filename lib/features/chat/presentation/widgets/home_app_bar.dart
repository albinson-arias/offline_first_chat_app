import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: const Text(
        'AlbinsonChat',
        style: TextStyle(
          fontWeight: FontWeight.w900,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              sl<AuthRepository>().signOut();
            },
            child: const Icon(
              CupertinoIcons.search,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
