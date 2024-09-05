import 'package:flutter/material.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';
import 'package:offline_first_chat_app/src/gen/assets.gen.dart';

class RoomListTile extends StatelessWidget {
  const RoomListTile({
    required this.room,
    super.key,
  });
  final Room room;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(
        bottom: 20,
      ),
      child: InkWell(
        // onTap: () => context.pushNamed(
        //   ChatPage.routeName,
        //   extra: chat,
        // ),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Row(
          children: [
            ClipOval(
              child: room.imageUrl == null
                  ? Image.asset(
                      Assets.profilePics.a1.path,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      room.imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        room.name,
                        style: context.textTheme.titleSmall,
                      ),
                      const Spacer(),
                      Text(
                        '${room.createdAt.hour.toString().padLeft(2, '0')}'
                        ':${room.createdAt.minute.toString().padLeft(2, '0')}',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: room.unreadMessages > 0 ? 2 : 6),
                  Row(
                    children: [
                      if (room.lastSenderIsMe)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            switch (room.lastMessageStatus) {
                              MessageStatus.delivered => Icons.done_all_rounded,
                              MessageStatus.read => Icons.done_all_rounded,
                              MessageStatus.sending =>
                                Icons.access_time_rounded,
                              MessageStatus.sent => Icons.done_rounded,
                            },
                            size: 18,
                            color: switch (room.lastMessageStatus) {
                              MessageStatus.read => Colors.blue,
                              _ => null
                            },
                          ),
                        ),
                      Expanded(
                        child: Text(
                          room.lastMessage,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: room.unreadMessages > 0
                                ? FontWeight.bold
                                : FontWeight.w300,
                          ),
                        ),
                      ),
                      if (room.unreadMessages > 0) ...[
                        const SizedBox(width: 2),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Text(
                            '2',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
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
