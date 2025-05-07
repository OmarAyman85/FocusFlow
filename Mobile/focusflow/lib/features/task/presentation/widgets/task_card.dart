import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:go_router/go_router.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final Map<String, String> userMap;
  final String createdByName;
  final String workspaceId;
  final String boardId;

  const TaskCard({
    super.key,
    required this.task,
    required this.userMap,
    required this.createdByName,
    required this.workspaceId,
    required this.boardId,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      color: AppPallete.gradient2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit:
                      FlexFit
                          .loose, // This allows the Text widget to take up as much space as needed
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.gradient1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {
                    GoRouter.of(context).push(
                      '/workspace/$workspaceId/board/$boardId/task/${task.id}',
                      extra: {'task': task, 'createdByName': createdByName},
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              task.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 12),

            // Priority
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(task.priority),
                  backgroundColor: _getPriorityColor(task.priority),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Due Date
            if (task.dueDate != null)
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else
              const Text(
                'No due date',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),

            const SizedBox(height: 12),

            // Created By
            Text(
              'Created By: $createdByName',
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
