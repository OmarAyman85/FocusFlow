import 'package:focusflow/features/workspace/domain/entities/member.dart';

class Workspace {
  final String name;
  final String description;
  final int numberOfMembers;
  final int numberOfProjects;
  final String createdById;
  final String createdByName;
  final List<Member> members;

  Workspace({
    required this.name,
    required this.description,
    required this.numberOfMembers,
    required this.numberOfProjects,
    required this.createdById,
    required this.createdByName,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'numberOfMembers': numberOfMembers,
      'numberOfProjects': numberOfProjects,
      'createdBy': {'id': createdById, 'name': createdByName},
      'members': members.map((m) => m.toMap()).toList(),
    };
  }

  factory Workspace.fromMap(Map<String, dynamic> map) {
    return Workspace(
      name: map['name'],
      description: map['description'],
      numberOfMembers: map['numberOfMembers'],
      numberOfProjects: map['numberOfProjects'],
      createdById: map['createdBy']['id'],
      createdByName: map['createdBy']['name'],
      members: List<Member>.from(
        (map['members'] ?? []).map((m) => Member.fromMap(m)),
      ),
    );
  }
}
