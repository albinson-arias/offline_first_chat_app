import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/story.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/rooms_cubit/rooms_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/widgets/widgets.dart';
import 'package:offline_first_chat_app/src/common/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      bottomNavigationBar: const AppBottomNavigationBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 91,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: Story.stories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Row(
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        AddStoryButton(),
                      ],
                    );
                  }
                  final story = Story.stories[index - 1];
                  return StoryButton(
                    onTap: () {},
                    name: story.name,
                    imageUrl: story.imageUrl,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ).copyWith(
                bottom: 12,
              ),
              child: Text(
                'Chats',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          BlocBuilder<RoomsCubit, RoomsState>(
            builder: (context, state) {
              return switch (state) {
                (final RoomsLoaded state) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final room = state.rooms[index];
                        return RoomListTile(
                          room: room,
                        );
                      },
                      childCount: state.rooms.length,
                    ),
                  ),
                _ => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}
