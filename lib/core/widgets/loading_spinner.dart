import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_pallete.dart';

class LoadingSpinnerWidget extends StatelessWidget {
  const LoadingSpinnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppPallete.gradient1),
    );
  }
}
