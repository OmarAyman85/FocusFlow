import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/core/entities/member.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/attachment_entity.dart';
import 'attachment_model.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.assignedTo,
    required super.status,
    required super.priority,
    super.dueDate,
    required super.createdAt,
    required super.createdById,
    required super.createdByName,
    required super.attachments,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map, String taskId) {
    return TaskModel(
      id: taskId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      assignedTo: List<Member>.from(
        (map['assignedTo'] ?? []).map((m) => Member.fromMap(m)),
      ),
      status: map['status'] ?? 'todo',
      priority: map['priority'] ?? 'medium',
      dueDate:
          map['dueDate'] != null
              ? (map['dueDate'] as Timestamp).toDate()
              : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdById: map['createdBy']?['id']?.toString() ?? '',
      createdByName: map['createdBy']?['name']?.toString() ?? '',
      attachments:
          (map['attachments'] as List<dynamic>? ?? [])
              .map((a) => AttachmentModel.fromMap(Map<String, dynamic>.from(a)))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'assignedTo': assignedTo.map((m) => m.toMap()).toList(),
      'assignedToIds': assignedTo.map((m) => m.id).toList(),
      'status': status,
      'priority': priority,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': {'id': createdById, 'name': createdByName},
      'attachments':
          attachments
              .map((a) => AttachmentModel.fromEntity(a).toMap())
              .toList(),
    };
  }

  factory TaskModel.fromEntity(TaskEntity entity) => TaskModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    assignedTo: entity.assignedTo,
    status: entity.status,
    priority: entity.priority,
    dueDate: entity.dueDate,
    createdAt: entity.createdAt,
    createdById: entity.createdById,
    createdByName: entity.createdByName,
    attachments: entity.attachments,
  );

  TaskEntity toEntity() => this;

  @override
  TaskModel copyWith({
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
    return TaskModel(
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
