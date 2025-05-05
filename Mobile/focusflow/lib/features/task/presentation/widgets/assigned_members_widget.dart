import 'package:flutter/material.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/core/services/add_member_dialog.dart';
import 'package:focusflow/core/services/user_service.dart';

class AssignedMembersWidget extends StatelessWidget {
  final String boardId;
  final String workspaceId;
  final List<String> assignedTo;
  final Function(String) onMemberAdded;
  final Function(String) onMemberRemoved;

  const AssignedMembersWidget({
    super.key,
    required this.boardId,
    required this.assignedTo,
    required this.onMemberAdded,
    required this.onMemberRemoved,
    required this.workspaceId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Assigned Members'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () async {
                await AddMemberDialog.open(
                  context: context,
                  getUsers:
                      () => sl<UserService>().getBoardMembers(
                        workspaceId,
                        boardId,
                      ),
                  onUserSelected: (user) async {
                    if (!assignedTo.contains(user.name)) {
                      onMemberAdded(user.name);
                    }
                  },
                  title: 'Add Member to Task',
                );
                return;
              },
            ),
          ],
        ),
        Wrap(
          spacing: 8.0,
          children:
              assignedTo
                  .map(
                    (name) => Chip(
                      label: Text(name),
                      onDeleted: () => onMemberRemoved(name),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
