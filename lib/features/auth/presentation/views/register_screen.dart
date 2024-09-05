import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:offline_first_chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:offline_first_chat_app/features/auth/presentation/widgets/password_field.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';
import 'package:offline_first_chat_app/src/core/utils/constants.dart';
import 'package:offline_first_chat_app/src/core/utils/core_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;
    await context
        .read<AuthCubit>()
        .signUp(username: username, email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.failure.errorMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: formPadding,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return 'The email is not valid';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                formSpacer,
                PasswordField(
                  passwordController: _passwordController,
                  textInputAction: TextInputAction.next,
                ),
                formSpacer,
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    label: Text('Username'),
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => isLoading ? null : _signUp(),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Required';
                    }
                    final isValid =
                        RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                    if (!isValid) {
                      return '3-24 long with alphanumeric or underscore';
                    }
                    return null;
                  },
                ),
                formSpacer,
                ElevatedButton(
                  onPressed: isLoading ? null : _signUp,
                  child: const Text('Register'),
                ),
                formSpacer,
                TextButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.login.name);
                  },
                  child: const Text('I already have an account'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
