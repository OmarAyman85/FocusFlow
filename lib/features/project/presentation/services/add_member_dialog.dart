import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/project/presentation/cubit/project_cubit.dart';

class AddProjectMemberDialog {
  static Future<void> openAddProjectMemberDialog(
    BuildContext context,
    String projectId,
    String workspaceId,
  ) async {
    final users =
        await context.read<ProjectCubit>().getUsers(); // Implement this
    final selectedUser = await showDialog<Member>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Add Project Member"),
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
      context.read<ProjectCubit>().addProjectMember(
        workspaceId,
        projectId,
        selectedUser,
      );
    }
  }
}
