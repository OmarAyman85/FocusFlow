import 'package:focusflow/core/entities/member.dart';

class Board {
  final String id;
  final String workspaceId;
  final String name;
  final String description;
  final int numberOfMembers;
  final int numberOfTasks;
  final String createdById;
  final String createdByName;
  final List<Member> members;

  Board({
    required this.id,
    required this.workspaceId,
    required this.name,
    required this.description,
    required this.numberOfMembers,
    required this.numberOfTasks,
    required this.createdById,
    required this.createdByName,
    required this.members,
  });
}
