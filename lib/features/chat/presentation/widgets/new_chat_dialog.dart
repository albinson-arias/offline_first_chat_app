import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/widgets.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';

class NewChatDialog extends StatelessWidget {
  const NewChatDialog({
    super.key,
  });

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
                  NewChatDialogOption(
                    onTap: () {},
                    icon: HugeIcons.strokeRoundedBubbleChatAdd,
                    title: 'New Chat',
                    subtitle: 'Send a message to your contacts',
                  ),
                  const Divider(),
                  NewChatDialogOption(
                    onTap: () {},
                    icon: HugeIcons.strokeRoundedContactBook,
                    title: 'New Contact',
                    subtitle: 'Add a contact to be able to send messages',
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
                                  color: Colors.blue,
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
