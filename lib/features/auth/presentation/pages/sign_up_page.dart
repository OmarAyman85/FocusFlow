import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/themes/app_pallete.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/auth/presentation/widgets/auth_button.dart';
import 'package:focusflow/features/auth/presentation/widgets/auth_field.dart';
import 'package:focusflow/injection_container.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignUpPage());
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
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text('FocusFlow')),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign Up Successful!')),
                  );
                  GoRouter.of(context).go('/home');
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppPallete.gradient1,
                    ),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    AuthField(hintText: 'Name', controller: _nameController),
                    SizedBox(height: 15),
                    AuthField(hintText: 'Email', controller: _emailController),
                    SizedBox(height: 15),
                    AuthField(
                      hintText: 'Password',
                      isObsecureText: true,
                      controller: _passwordController,
                    ),
                    SizedBox(height: 20),
                    AuthButton(
                      buttonText: "Sign Up",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            SignUpRequested(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go('/signin');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: ' Sign In',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: AppPallete.gradient1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
