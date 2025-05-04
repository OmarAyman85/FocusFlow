import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/widgets/loading_spinner_widget.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';
import 'package:focusflow/features/workspace/presentation/widgets/workspace_list.dart';
import 'package:focusflow/features/workspace/presentation/widgets/add_workspace_button.dart';
import 'package:go_router/go_router.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          GoRouter.of(context).go('/signin');
        } else if (state is AuthAuthenticated) {
          context.read<WorkspaceCubit>().loadWorkspaces(state.user.uid);
        }
      },
      child: Scaffold(
        appBar: MainAppBar(
          title: 'FocusFLow',
          showBackButton: false,
          profileButtonType: ProfileButtonType.logoutIcon,
        ),
        body: BlocBuilder<WorkspaceCubit, WorkspaceState>(
          builder: (context, state) {
            final authState = context.read<AuthBloc>().state;
            final username =
                authState is AuthAuthenticated ? authState.user.name : 'User';

            if (state is WorkspaceLoading) {
              return const LoadingSpinnerWidget();
            } else if (state is WorkspaceLoaded) {
              return WorkspaceList(
                username: username,
                workspaces: state.workspaces,
              );
            } else if (state is WorkspaceError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No workspaces found.'));
            }
          },
        ),
        floatingActionButton: const AddWorkspaceButton(),
      ),
    );
  }
}
