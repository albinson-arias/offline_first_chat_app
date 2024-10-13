import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:offline_first_chat_app/features/auth/presentation/widgets/password_field.dart';
import 'package:offline_first_chat_app/src/core/utils/constants.dart';
import 'package:offline_first_chat_app/src/core/utils/core_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _signIn() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final email = _emailController.value.text;
    final password = _passwordController.value.text;
    await context.read<AuthCubit>().signIn(email: email, password: password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          appBar: AppBar(title: const Text('Sign In')),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: formPadding,
              children: [
                TextFormField(
                  key: const Key('LoginScreen-email_field'),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return 'The email is not valid';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                formSpacer,
                PasswordField(
                  passwordController: _passwordController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: isLoading ? null : _signIn,
                ),
                formSpacer,
                ElevatedButton(
                  onPressed: isLoading ? null : _signIn,
                  child: isLoading
                      ? const Center(
                          key: Key('LoginScreen-loading_button'),
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
