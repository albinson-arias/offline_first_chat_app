import 'package:flutter/material.dart';
import 'package:offline_first_chat_app/src/core/extensions/bool_ext.dart';
import 'package:offline_first_chat_app/src/core/utils/constants.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.passwordController,
    required this.textInputAction,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController passwordController;
  final TextInputAction textInputAction;
  final VoidCallback? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: isHidden,
      decoration: InputDecoration(
        label: const Text('Password'),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isHidden = isHidden.toggle();
            });
          },
          child: Icon(isHidden ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (_) => widget.onSubmitted?.call(),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }

        if (!passwordRegex.hasMatch(value)) {
          return 'Minimum of eight characters,'
              ' one letter and one number';
        }

        return null;
      },
    );
  }
}
