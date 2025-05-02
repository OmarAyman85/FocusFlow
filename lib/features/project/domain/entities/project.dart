import 'package:focusflow/features/project/domain/entities/member.dart';

class Project {
  final String id;
  final String workspaceId;
  final String name;
  final String description;
  final int numberOfMembers;
  final int numberOfBoards;
  final String createdById;
  final String createdByName;
  final List<Member> members;

  Project({
    required this.id,
    required this.workspaceId,
    required this.name,
    required this.description,
    required this.numberOfMembers,
    required this.numberOfBoards,
    required this.createdById,
    required this.createdByName,
    required this.members,
  });
}
