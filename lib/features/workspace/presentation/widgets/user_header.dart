import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final String username;

  const UserHeader({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 120),
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: Text(
            initial,
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Welcome back',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
