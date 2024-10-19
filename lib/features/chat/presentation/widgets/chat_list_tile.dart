import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/message_status.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';
import 'package:offline_first_chat_app/src/core/extensions/string_ext.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';
import 'package:offline_first_chat_app/src/gen/assets.gen.dart';

class RoomListTile extends StatelessWidget {
  const RoomListTile({
    required this.room,
    super.key,
  });
  final Room room;

  String get formattedTime {
    return '${room.lastMessageTimeSent!.hour.toString().padLeft(2, '0')}'
        ':${room.lastMessageTimeSent!.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pushNamed(
          AppRoutes.chat.name,
          pathParameters: {'roomId': room.id},
          extra: room,
        );
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ).copyWith(
          bottom: 20,
        ),
        child: Row(
          children: [
            ClipOval(
              child: room.imageUrl == null
                  ? Assets.icons.profile.svg(
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: room.imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: Colors.blue,
                      ),
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
                        maxLines: 1,
                      ),
                      const Spacer(),
                      if (room.lastMessageTimeSent != null)
                        Text(
                          formattedTime,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: room.unreadMessages > 0 ? 2 : 6),
                  Row(
                    children: [
                      if (room.lastSenderIsMe && room.lastMessageStatus != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            switch (room.lastMessageStatus!) {
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
                      if (room.lastMessage != null)
                        Expanded(
                          child: Text(
                            room.lastMessage!.removeNewLines(),
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
                            room.unreadMessages.toString(),
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
