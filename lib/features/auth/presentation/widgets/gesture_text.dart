import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:go_router/go_router.dart';

class GestureText extends StatelessWidget {
  final String route;
  final String text;
  final String actionText;
  const GestureText({
    super.key,
    required this.route,
    required this.text,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go(route);
      },
      child: RichText(
        text: TextSpan(
          text: text,
          style: Theme.of(context).textTheme.titleMedium,
          children: [
            TextSpan(
              text: actionText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppPallete.gradient1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
