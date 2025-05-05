import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/widgets/loading_spinner_widget.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import '../widgets/board_form.dart';

class BoardFormPage extends StatelessWidget {
  final String workspaceId;
  const BoardFormPage({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return BoardForm(
            workspaceId: workspaceId,
            userId: state.user.uid,
            userName: state.user.name,
          );
        } else {
          return const Scaffold(
            body: Center(child: LoadingSpinnerWidget()),
          );
        }
      },
    );
  }
}
