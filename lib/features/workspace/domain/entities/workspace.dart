// import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'member.dart';

class Workspace {
  final String id;
  final String name;
  final String description;
  final int numberOfMembers;
  final int numberOfProjects;
  final String createdById;
  final String createdByName;
  final List<Member> members;

  Workspace({
    required this.id,
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

  factory Workspace.fromMap(Map<String, dynamic> map, String id) {
    return Workspace(
      id: id,
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

  Workspace copyWith({
    String? id,
    String? name,
    String? description,
    int? numberOfMembers,
    int? numberOfProjects,
    String? createdById,
    String? createdByName,
    List<Member>? members,
  }) {
    return Workspace(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      numberOfMembers: numberOfMembers ?? this.numberOfMembers,
      numberOfProjects: numberOfProjects ?? this.numberOfProjects,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      members: members ?? this.members,
    );
  }
}
