import 'package:flutter/material.dart';
import 'package:focusflow/features/auth/presentation/widgets/sign_out_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusFlow'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SignOutButton(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Welcome to FocusFlow!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
