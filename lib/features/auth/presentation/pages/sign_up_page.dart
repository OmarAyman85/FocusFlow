import 'package:flutter/material.dart';
import 'package:focusflow/core/utils/themes/app_pallete.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_up.dart';
import 'package:focusflow/features/auth/presentation/pages/sign_in_page.dart';
import 'package:focusflow/features/auth/presentation/widgets/auth_button.dart';
import 'package:focusflow/features/auth/presentation/widgets/auth_field.dart';
import 'package:focusflow/injection_container.dart';

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
                'Sign Up',
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
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
                  sl<SignUpUseCase>().call(
                    params: UserModel(
                      email: _emailController.text,
                      name: _nameController.text,
                      password: _passwordController.text,
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(SignInPage.route());
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
          ),
        ),
      ),
    );
  }
}
