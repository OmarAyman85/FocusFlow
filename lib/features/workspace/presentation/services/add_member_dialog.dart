import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';

class AddMemberDialog {
  static Future<void> openAddMemberDialog(
    BuildContext context,
    Workspace workspace,
  ) async {
    final users =
        await context.read<WorkspaceCubit>().getUsers(); // Fetch users
    final selectedUser = await showDialog<Member>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Add Member"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<Member>(
                  hint: const Text("Select a User"),
                  onChanged: (Member? user) {
                    Navigator.of(
                      ctx,
                    ).pop(user); // Close the dialog with the selected user
                  },
                  items:
                      users.map((user) {
                        return DropdownMenuItem<Member>(
                          value: user,
                          child: Text(user.name),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
    );

    if (selectedUser != null) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final userId = authState.user.uid;
        context.read<WorkspaceCubit>().addWorkspaceMember(
          workspace.id,
          selectedUser,
          userId,
        );
      }
    }
  }
}
