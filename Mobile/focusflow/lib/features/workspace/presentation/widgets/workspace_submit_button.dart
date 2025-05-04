import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_pallete.dart';

class WorkspaceSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WorkspaceSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.backgroundColor,
        foregroundColor: AppPallete.gradient1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text('Create Workspace'),
    );
  }
}
