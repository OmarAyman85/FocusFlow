import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/widgets/loading_spinner_widget.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/presentation/widgets/workspace_form_fields.dart';

class WorkspaceForm extends StatelessWidget {
  final String userId;

  const WorkspaceForm({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final userId = state.user.uid;
          final userName = state.user.name;

          return Scaffold(
            appBar: const MainAppBar(title: 'Create Workspace'),
            body: WorkspaceFormFields(userId: userId, userName: userName),
          );
        } else {
          return const LoadingSpinnerWidget();
        }
      },
    );
  }
}
