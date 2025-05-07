import 'package:focusflow/core/entities/member.dart';

import 'attachment_entity.dart';

class TaskEntity {
  final String id;
  final String title;
  final String description;
  final List<Member> assignedTo;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final String createdById;
  final String createdByName;
  final List<AttachmentEntity> attachments;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    required this.createdById,
    required this.createdByName,
    required this.attachments,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    List<Member>? assignedTo,
    String? status,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    String? createdById,
    String? createdByName,
    List<AttachmentEntity>? attachments,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      attachments: attachments ?? this.attachments,
    );
  }
}
