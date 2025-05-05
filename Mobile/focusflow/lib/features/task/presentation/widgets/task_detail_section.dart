import 'package:flutter/material.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/utils/task_color_utils.dart';
import 'package:focusflow/features/task/presentation/widgets/task_info_chip.dart';

class TaskDetailSection extends StatelessWidget {
  final TaskEntity task;
  final String createdByName;
  final VoidCallback onDelete;

  const TaskDetailSection({
    super.key,
    required this.task,
    required this.createdByName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              task.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                TaskInfoChip(
                  label: task.priority,
                  color: TaskColorUtils.priorityColor(task.priority),
                ),
                TaskInfoChip(
                  label: task.status,
                  color: TaskColorUtils.statusColor(task.status),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _infoRow(
              Icons.calendar_today,
              task.dueDate != null
                  ? 'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}'
                  : 'No due date',
            ),
            const SizedBox(height: 20),
            _infoRow(Icons.person_outline, 'Created by: $createdByName'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                  ),
                  child: const Text('Delete Task'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
