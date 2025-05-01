import 'package:flutter/material.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_out.dart';
import 'package:focusflow/features/auth/presentation/pages/sign_up_page.dart';
import 'package:focusflow/features/auth/presentation/widgets/auth_button.dart';
import 'package:focusflow/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FocusFlow')),
      body: Center(
        child: Column(
          children: [
            Text(
              'Welcome to FocusFlow!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AuthButton(
              buttonText: 'Log out',
              onPressed: () {
                sl<SignOutUseCase>().call().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign Out Successful!')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                });
                // Handle sign-up action
              },
            ),
          ],
        ),
      ),
    );
  }
}
