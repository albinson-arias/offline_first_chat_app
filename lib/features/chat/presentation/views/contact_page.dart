import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';
import 'package:offline_first_chat_app/src/gen/assets.gen.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact info',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Center(
              child: ClipOval(
                child: profile.imageUrl == null
                    ? Assets.icons.profile.svg(
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: profile.imageUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                          value: downloadProgress.progress,
                          color: Colors.blue,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                profile.username,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                'Bio',
                style: context.textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        profile.bio,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
