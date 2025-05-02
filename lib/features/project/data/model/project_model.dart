import 'package:focusflow/features/project/domain/entities/project.dart';

class ProjectModel extends Project {
  ProjectModel({
    required super.id,
    required super.workspaceId,
    required super.name,
    required super.description,
    required super.memberIds,
    required super.createdBy,
    required super.createdByName,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      workspaceId: map['workspaceId'],
      name: map['name'],
      description: map['description'],
      memberIds: List<String>.from(map['memberIds']),
      createdBy: map['createdBy'],
      createdByName: map['createdByName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workspaceId': workspaceId,
      'name': name,
      'description': description,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'createdByName': createdByName,
    };
  }
}
