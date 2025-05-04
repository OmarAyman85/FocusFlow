import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/services/add_member_dialog.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:go_router/go_router.dart';

class WorkspaceCard extends StatelessWidget {
  final Workspace workspace;

  const WorkspaceCard({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 3,
      color: AppPallete.gradient2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    workspace.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.gradient1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.view_stream, size: 20),
                  onPressed: () async {
                    final result = await GoRouter.of(
                      context,
                    ).push('/workspace/${workspace.id}/boards');
                    if (result == 'board_added') {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is AuthAuthenticated) {
                        context.read<WorkspaceCubit>().loadWorkspaces(
                          authState.user.uid,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              workspace.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                            () => context.read<WorkspaceCubit>().getUsers(),
                        onUserSelected: (selectedUser) {
                          final authState = context.read<AuthBloc>().state;
                          if (authState is AuthAuthenticated) {
                            final userId = authState.user.uid;
                            context.read<WorkspaceCubit>().addWorkspaceMember(
                              workspace.id,
                              selectedUser,
                              userId,
                            );
                          }
                          return Future.value();
                        },
                      ),
                ),
                IconButton(
                  onPressed: () async {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is AuthAuthenticated) {
                      final userId = authState.user.uid;

                      await context.read<WorkspaceCubit>().deleteWorkspace(
                        workspace.id,
                        userId,
                      );
                      await context.read<WorkspaceCubit>().loadWorkspaces(
                        userId,
                      );
                    }
                  },
                  icon: const Icon(Icons.delete, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
