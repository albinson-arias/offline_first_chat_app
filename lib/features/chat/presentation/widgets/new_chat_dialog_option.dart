import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';

class NewChatDialogOption extends StatelessWidget {
  const NewChatDialogOption({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            HugeIcon(
              icon: icon,
              color: Colors.black,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
