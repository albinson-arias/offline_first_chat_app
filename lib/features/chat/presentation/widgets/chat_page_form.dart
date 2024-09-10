import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';

class ChatPageForm extends StatefulWidget {
  const ChatPageForm({
    required this.roomId,
    super.key,
  });
  final String roomId;

  @override
  State<ChatPageForm> createState() => _ChatPageFormState();
}

class _ChatPageFormState extends State<ChatPageForm> {
  late final TextEditingController controller;
  bool canSendMessage = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController()..addListener(checkIfCanSendMessage);
  }

  void checkIfCanSendMessage() {
    if (controller.value.text.trim().isEmpty) {
      setState(() {
        canSendMessage = false;
      });
      return;
    }
    setState(() {
      canSendMessage = true;
    });
    return;
  }

  void sendMessage(String message) {
    controller.text = message;
    if (!canSendMessage) return;

    context.read<ChatCubit>().sendMessage(
          widget.roomId,
          controller.value.text.trim(),
        );

    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xffF4F4F5),
      child: SafeArea(
        child: MessageBar(
          onSend: sendMessage,
        ),
      ),
    );
  }
}
