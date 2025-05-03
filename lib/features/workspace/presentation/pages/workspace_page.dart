import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/services/add_member_dialog.dart';
import 'package:focusflow/core/widgets/loading_spinner.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';
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
        appBar: const MainAppBar(title: 'Workspaces', showBackButton: false),
        body: BlocBuilder<WorkspaceCubit, WorkspaceState>(
          builder: (context, state) {
            if (state is WorkspaceLoading) {
              return const LoadingSpinnerWidget();
            } else if (state is WorkspaceLoaded) {
              final workspaces = state.workspaces;

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: workspaces.length,
                itemBuilder: (context, index) {
                  final workspace = workspaces[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 3,
                    color: AppPallete.gradient2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workspace.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppPallete.gradient1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            workspace.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Boards: ${workspace.numberOfBoards}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Members: ${workspace.numberOfMembers}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Created by: ${workspace.createdByName}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.person_add),
                                onPressed:
                                    () => AddMemberDialog.open(
                                      context: context,
                                      title: 'Add Workspace Member',
                                      getUsers:
                                          () =>
                                              context
                                                  .read<WorkspaceCubit>()
                                                  .getUsers(),
                                      onUserSelected: (selectedUser) async {
                                        final authState =
                                            context.read<AuthBloc>().state;
                                        if (authState is AuthAuthenticated) {
                                          final userId = authState.user.uid;
                                          context
                                              .read<WorkspaceCubit>()
                                              .addWorkspaceMember(
                                                workspace.id,
                                                selectedUser,
                                                userId,
                                              );
                                        }
                                      },
                                    ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final workspaceId = workspace.id;

                                  final result = await GoRouter.of(
                                    context,
                                  ).push('/workspace/$workspaceId/boards');

                                  if (result == 'board_added') {
                                    final authState =
                                        context.read<AuthBloc>().state;
                                    if (authState is AuthAuthenticated) {
                                      final userId = authState.user.uid;
                                      context
                                          .read<WorkspaceCubit>()
                                          .loadWorkspaces(userId);
                                    }
                                  }
                                },
                                child: const Text('Enter'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is WorkspaceError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No workspaces found.'));
            }
          },
        ),
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return FloatingActionButton(
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
        ),
      ),
    );
  }
}
