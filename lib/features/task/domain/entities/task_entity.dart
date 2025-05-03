import 'attachment_entity.dart';

class TaskEntity {
  final String id;
  final String title;
  final String description;
  final List<String> assignedTo;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final String createdBy;
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
    required this.createdBy,
    required this.attachments,
  });
}
