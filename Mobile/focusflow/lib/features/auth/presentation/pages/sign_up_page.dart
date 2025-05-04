import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/form_validators.dart';
import 'package:focusflow/core/widgets/loading_spinner_widget.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/auth/presentation/widgets/auth_button.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';
import 'package:focusflow/features/auth/presentation/widgets/gesture_text.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FocusFlow')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign Up Successful!')),
                );
                context.read<AuthBloc>().add(AppStarted());
                context.go('/workspace'); // prefer `go` to reset stack
              } else if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const LoadingSpinnerWidget();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  AppTextFormField(
                    label: 'Name',
                    controller: _nameController,
                    validator: FormValidators.validateName,
                  ),
                  const SizedBox(height: 15),
                  AppTextFormField(
                    label: 'Email',
                    controller: _emailController,
                    validator: FormValidators.validateEmail,
                  ),
                  const SizedBox(height: 15),
                  AppTextFormField(
                    label: 'Password',
                    controller: _passwordController,
                    isObscureText: true,
                    validator: FormValidators.validatePasswordSignUp,
                  ),
                  const SizedBox(height: 20),
                  AuthButton(
                    buttonText: "Sign Up",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final user = UserModel(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          uid: '',
                        );
                        context.read<AuthBloc>().add(SignUpRequested(user));
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  GestureText(
                    route: '/signin',
                    text: 'Already have an account? ',
                    actionText: 'Sign In',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
