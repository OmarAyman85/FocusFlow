import 'package:flutter/material.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/services/task_detail_service.dart';
import 'package:focusflow/features/task/presentation/widgets/task_detail_section.dart';
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

  @override
  Widget build(BuildContext context) {
    final service = TaskDetailService(context.read());

    return Scaffold(
      appBar: AppBar(title: Text(task.title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TaskDetailSection(
          task: task,
          createdByName: createdByName,
          onDelete: () async {
            await service.deleteTask(workspaceId, boardId, task.id);
            GoRouter.of(context).pop();
          },
        ),
      ),
    );
  }
}
