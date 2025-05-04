import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class AddWorkspaceButton extends StatelessWidget {
  const AddWorkspaceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return FloatingActionButton(
            backgroundColor: AppPallete.backgroundColor,
            foregroundColor: AppPallete.gradient1,
            onPressed: () {
              final userId = state.user.uid;
              GoRouter.of(context).push('/workspace-form/$userId');
            },
            child: const Icon(Icons.add),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
