import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/room.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/widgets.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';
import 'package:offline_first_chat_app/src/gen/assets.gen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({required this.room, super.key});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF4F4F5),
        title: InkWell(
          key: const Key('ChatPage-AppBarTitle'),
          onTap: () {
            context.pushNamed(
              AppRoutes.contact.name,
              extra: room.otherParticipant,
              pathParameters: {'roomId': room.id},
            );
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Row(
            children: [
              ClipOval(
                child: room.imageUrl == null
                    ? Assets.icons.profile.svg(
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: room.imageUrl!,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                          value: downloadProgress.progress,
                          color: Colors.blue,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Text(
                room.name,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const ChatPageBody(),
          ChatPageForm(
            roomId: room.id,
          ),
        ],
      ),
    );
  }
}
