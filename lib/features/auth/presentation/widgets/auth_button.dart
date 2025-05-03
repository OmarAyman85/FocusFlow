import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_pallete.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const AuthButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [AppPallete.gradient2, AppPallete.gradient1],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
