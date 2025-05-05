import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/core/services/add_member_dialog.dart';
import 'package:focusflow/core/services/user_service.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/board.dart';
import '../cubit/board_cubit.dart';

class BoardCard extends StatelessWidget {
  final Board board;
  final String workspaceId;

  const BoardCard({super.key, required this.board, required this.workspaceId});

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
                    board.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.gradient1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.view_compact, size: 20),
                  onPressed: () {
                    GoRouter.of(
                      context,
                    ).push('/workspace/$workspaceId/board/${board.id}/tasks');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              board.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Tasks: ${board.numberOfTasks}',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 16),
                Text(
                  'Members: ${board.numberOfMembers}',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Created by: ${board.createdByName}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {
                    AddMemberDialog.open(
                      context: context,
                      title: 'Add Board Member',
                      getUsers:
                          () => sl<UserService>().getWorkspaceMembers(
                            workspaceId,
                          ),
                      onUserSelected: (selectedUser) async {
                        await context.read<BoardCubit>().addBoardMember(
                          workspaceId,
                          board.id,
                          selectedUser,
                        );
                        return;
                      },
                    );
                  },
                ),
                IconButton(
                  onPressed: () async {
                    await context.read<BoardCubit>().deleteBoard(
                      workspaceId,
                      board.id,
                    );
                    await context.read<BoardCubit>().loadBoards(workspaceId);
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
