import '../../domain/entities/workspace.dart';

class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    required super.id,
    required super.name,
    required super.createdBy,
    required super.members,
  });

  factory WorkspaceModel.fromMap(Map<String, dynamic> map, String id) {
    return WorkspaceModel(
      id: id,
      name: map['name'],
      createdBy: map['createdBy'],
      members: List<String>.from(map['members']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'createdBy': createdBy, 'members': members};
  }
}
