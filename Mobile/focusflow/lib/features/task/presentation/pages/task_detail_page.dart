import 'package:flutter/material.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';

class TaskDetailPage extends StatelessWidget {
  final TaskEntity task;
  final String createdByName;

  const TaskDetailPage({
    super.key,
    required this.task,
    required this.createdByName,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red.shade300;
      case 'Medium':
        return Colors.orange.shade300;
      case 'Low':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'To Do':
        return Colors.blue.shade100;
      case 'In Progress':
        return Colors.orange.shade100;
      case 'Completed':
        return Colors.green.shade100;
      case 'Blocked':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              task.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 12),

            // Status and Priority
            Wrap(
              spacing: 8,
              children: [
                // priority chip
                Chip(
                  label: Text(task.priority),
                  backgroundColor: _getPriorityColor(task.priority),
                  labelStyle: const TextStyle(fontSize: 14),
                ),
                // Status Chip
                Chip(
                  label: Text(task.status),
                  backgroundColor: _getStatusColor(task.status),
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Due Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Due: ${task.dueDate?.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Created By
            Text(
              'Created By: $createdByName',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
