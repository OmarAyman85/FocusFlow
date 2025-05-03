import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/board/presentation/cubit/board_cubit.dart';

class AddBoardMemberDialog {
  static Future<void> openAddBoardMemberDialog(
    BuildContext context,
    String boardId,
    String workspaceId,
  ) async {
    final users = await context.read<BoardCubit>().getUsers(); // Implement this
    final selectedUser = await showDialog<Member>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Add Board Member"),
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
      context.read<BoardCubit>().addBoardMember(
        workspaceId,
        boardId,
        selectedUser,
      );
    }
  }
}
