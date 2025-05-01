import 'package:equatable/equatable.dart';

class Workspace extends Equatable {
  final String id;
  final String name;
  final String createdBy;
  final List<String> members;

  const Workspace({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.members,
  });

  @override
  List<Object?> get props => [id, name, createdBy, members];

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'createdBy': createdBy, 'members': members};
  }

  factory Workspace.fromMap(Map<String, dynamic> map, String id) {
    return Workspace(
      id: id,
      name: map['name'],
      createdBy: map['createdBy'],
      members: List<String>.from(map['members']),
    );
  }
}
