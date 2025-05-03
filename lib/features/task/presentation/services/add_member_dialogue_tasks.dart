import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/board/domain/entities/member.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';

class AddMemberDialog {
  static Future<void> openAddMemberDialog(
    BuildContext context,
    TaskEntity task,
  ) async {
    // Fetch users for the task
    final users = await context.read<TaskCubit>().getUsers();
    final selectedUser = await showDialog<Member>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Add Member to Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<Member>(
                  hint: const Text("Select a User"),
                  onChanged: (Member? user) {
                    Navigator.of(ctx).pop(user);
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
        if (task.id.isEmpty) {
          return;
        }
        context.read<TaskCubit>().addTaskMember(
          taskId: task.id, // task.id should be non-null
          memberId: selectedUser.id, // Pass the selected user's ID
        );
      }
    }
  }
}
