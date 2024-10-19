import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_elastic_list_view/flutter_elastic_list_view.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';

class ChatPageBody extends StatelessWidget {
  const ChatPageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return switch (state) {
            (final ChatLoaded state) => ElasticListView.builder(
                reverse: true,
                itemBuilder: (context, index) {
                  final message = state.messages.elementAt(index);
                  late final bool shouldHaveTail;
                  if (index > 0) {
                    final nextMessage = state.messages.elementAt(index - 1);
                    if (nextMessage.profile.id != message.profile.id) {
                      shouldHaveTail = true;
                    } else {
                      shouldHaveTail = false;
                    }
                  } else {
                    shouldHaveTail = true;
                  }

                  return BubbleSpecialThree(
                    key: ValueKey(message.content),
                    text: message.content,
                    isSender: message.isMine,
                    color: message.isMine
                        ? const Color(0xFF1B97F3)
                        : const Color(0xFFE8E8EE),
                    tail: shouldHaveTail,
                    textStyle: message.isMine
                        ? const TextStyle(color: Colors.white, fontSize: 16)
                        : const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                  );
                },
                itemCount: state.messages.length,
              ),
            _ => const CircularProgressIndicator.adaptive()
          };
        },
      ),
    );
  }
}
