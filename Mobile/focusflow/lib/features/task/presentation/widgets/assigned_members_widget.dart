import 'package:flutter/material.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/core/services/add_member_dialog.dart';
import 'package:focusflow/core/services/user_service.dart';

class AssignedMembersWidget extends StatefulWidget {
  final String boardId;
  final String workspaceId;
  final List<Member> initialAssignedTo;
  final void Function(List<Member>)? onChanged;

  const AssignedMembersWidget({
    super.key,
    required this.boardId,
    required this.workspaceId,
    required this.initialAssignedTo,
    this.onChanged,
  });

  @override
  State<AssignedMembersWidget> createState() => _AssignedMembersWidgetState();
}

class _AssignedMembersWidgetState extends State<AssignedMembersWidget> {
  late List<Member> _assignedTo;

  @override
  void initState() {
    super.initState();
    _assignedTo = List<Member>.from(widget.initialAssignedTo);
  }

  void _addMember(Member member) {
    final alreadyExists = _assignedTo.any((m) => m.id == member.id);
    if (!alreadyExists) {
      setState(() {
        _assignedTo.add(member);
      });
      widget.onChanged?.call(_assignedTo);
    }
  }

  void _removeMember(Member member) {
    setState(() {
      _assignedTo.removeWhere((m) => m.id == member.id);
    });
    widget.onChanged?.call(_assignedTo);
  }

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
                  title: 'Assign Task to Member',
                  getUsers:
                      () => sl<UserService>().getBoardMembers(
                        widget.workspaceId,
                        widget.boardId,
                      ),
                  onUserSelected: (user) async {
                    _addMember(user);
                    return Future.value();
                  },
                );
              },
            ),
          ],
        ),
        Wrap(
          spacing: 8.0,
          children:
              _assignedTo
                  .map(
                    (member) => Chip(
                      label: Text(member.name),
                      onDeleted: () => _removeMember(member),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
