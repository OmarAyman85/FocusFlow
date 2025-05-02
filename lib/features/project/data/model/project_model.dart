import 'package:focusflow/features/project/domain/entities/member.dart';
import 'package:focusflow/features/project/domain/entities/project.dart';

class ProjectModel extends Project {
  ProjectModel({
    required super.id,
    required super.workspaceId,
    required super.name,
    required super.description,
    required super.numberOfMembers,
    required super.numberOfBoards,
    required super.createdById,
    required super.createdByName,
    required super.members,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      workspaceId: map['workspaceId'],
      name: map['name'],
      description: map['description'],
      numberOfMembers: map['numberOfMembers'] ?? 0,
      numberOfBoards: map['numberOfBoards'] ?? 0,
      createdById: map['createdById'],
      createdByName: map['createdByName'],
      members:
          (map['members'] as List<dynamic>? ?? [])
              .map((e) => Member.fromMap(e))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workspaceId': workspaceId,
      'name': name,
      'description': description,
      'numberOfMembers': numberOfMembers,
      'numberOfBoards': numberOfBoards,
      'createdById': createdById,
      'createdByName': createdByName,
      'members': members.map((e) => e.toMap()).toList(),
    };
  }
}
