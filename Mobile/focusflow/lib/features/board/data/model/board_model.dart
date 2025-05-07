import 'package:focusflow/features/board/domain/entities/board.dart';
import 'package:focusflow/core/entities/member.dart';

class BoardModel extends Board {
  BoardModel({
    required super.id,
    required super.workspaceId,
    required super.name,
    required super.description,
    required super.numberOfMembers,
    required super.numberOfTasks,
    required super.createdById,
    required super.createdByName,
    required super.members,
  });

  factory BoardModel.fromMap(Map<String, dynamic> map, String id) {
    return BoardModel(
      id: id,
      workspaceId: map['workspaceId'],
      name: map['name'],
      description: map['description'],
      numberOfMembers: map['numberOfMembers'] ?? 0,
      numberOfTasks: map['numberOfTasks'] ?? 0,
      createdById: map['createdBy']['id'],
      createdByName: map['createdBy']['name'],
      members: List<Member>.from(
        (map['members'] ?? []).map((m) => Member.fromMap(m)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workspaceId': workspaceId,
      'name': name,
      'description': description,
      'numberOfMembers': numberOfMembers,
      'numberOfTasks': numberOfTasks,
      'createdBy': {'id': createdById, 'name': createdByName},
      'members': members.map((m) => m.toMap()).toList(),
    };
  }
}
