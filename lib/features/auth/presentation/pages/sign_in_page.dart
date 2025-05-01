import 'package:flutter/material.dart';
import 'package:focusflow/core/utils/themes/app_pallete.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_in.dart';
import 'package:focusflow/features/auth/presentation/widgets/auth_button.dart';
import 'package:focusflow/features/auth/presentation/widgets/auth_field.dart';
import 'package:focusflow/injection_container.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignInPage());
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FocusFlow')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign In',
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              AuthField(hintText: 'Email', controller: _emailController),
              SizedBox(height: 15),
              AuthField(
                hintText: 'Password',
                isObsecureText: true,
                controller: _passwordController,
              ),
              SizedBox(height: 20),
              AuthButton(
                buttonText: "Sign In",
                onPressed: () {
                  sl<SignInUseCase>()
                      .call(
                        params: UserModel(
                          name: '',
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      )
                      .then((result) {
                        if (result.isRight()) {
                          GoRouter.of(context).go('/home');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sign In Successful!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sign In Failed')),
                          );
                        }
                      });
                },
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).go('/signup');
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: ' Sign Up',
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
          ),
        ),
      ),
    );
  }
}
