import 'package:flutter/material.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TaskDetailPage extends StatelessWidget {
  final TaskEntity task;
  final String createdByName;
  final String workspaceId;
  final String boardId;

  const TaskDetailPage({
    super.key,
    required this.task,
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
      appBar: AppBar(title: Text(task.title), centerTitle: true, elevation: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  task.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),

                // Chips
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Chip(
                      label: Text(task.priority),
                      backgroundColor: _getPriorityColor(task.priority),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Chip(
                      label: Text(task.status),
                      backgroundColor: _getStatusColor(task.status),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Due Date
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task.dueDate != null
                          ? 'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}'
                          : 'No due date',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Created By
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Created by: $createdByName',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Mark Complete Button
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement the logic to mark the task as completed.
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text('Mark as Complete'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await context.read<TaskCubit>().deleteTask(
                          workspaceId: workspaceId,
                          boardId: boardId,
                          taskId: task.id,
                        );
                        await context.read<TaskCubit>().loadTasks(
                          workspaceId: workspaceId,
                          boardId: boardId,
                        );
                        GoRouter.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text('Delete Task'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
