import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:focusflow/features/task/presentation/cubit/task_state.dart';
import 'package:go_router/go_router.dart';

class TaskPage extends StatefulWidget {
  final String workspaceId;
  final String boardId;

  const TaskPage({super.key, required this.workspaceId, required this.boardId});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<Map<String, String>> userIdToNameMap;

  @override
  void initState() {
    super.initState();
    userIdToNameMap = _buildUserIdToNameMap();

    Future.microtask(() {
      context.read<TaskCubit>().loadTasks(
        workspaceId: widget.workspaceId,
        boardId: widget.boardId,
      );
    });
  }

  Future<Map<String, String>> _buildUserIdToNameMap() async {
    try {
      final members = await context.read<TaskCubit>().getUsers();
      return {for (var member in members) member.id: member.name};
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Tasks'),
      body: FutureBuilder<Map<String, String>>(
        future: userIdToNameMap,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading users: ${snapshot.error}'),
            );
          }

          final userMap = snapshot.data ?? {};

          return BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TaskError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              if (state is TaskLoaded) {
                final tasks = state.tasks;

                if (tasks.isEmpty) {
                  return const Center(child: Text('No tasks found.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two cards per row
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                        0.7, // Adjust this ratio for a natural card height
                  ),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final createdByName =
                        userMap[task.createdBy] ?? task.createdBy;

                    return TaskCard(
                      task: task,
                      userMap: userMap,
                      createdByName: createdByName,
                    );
                  },
                );
              }

              return const SizedBox.shrink(); // fallback
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPallete.backgroundColor,
        foregroundColor: AppPallete.gradient1,
        onPressed: () {
          final path =
              '/workspace/${widget.workspaceId}/board/${widget.boardId}/task-form';
          GoRouter.of(context).push(path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final Map<String, String> userMap;
  final String createdByName;

  const TaskCard({
    super.key,
    required this.task,
    required this.userMap,
    required this.createdByName,
  });

  // Color _getStatusColor(String status) {
  //   switch (status) {
  //     case 'To Do':
  //       return Colors.blue.shade100;
  //     case 'In Progress':
  //       return Colors.orange.shade100;
  //     case 'Completed':
  //       return Colors.green.shade100;
  //     case 'Blocked':
  //       return Colors.red.shade100;
  //     default:
  //       return Colors.grey.shade100;
  //   }
  // }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                    // TODO: Navigate to task detail page
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

            // Status and Priority Chips
            Wrap(
              spacing: 8,
              children: [
                // Chip(
                //   label: Text(task.status),
                //   backgroundColor: _getStatusColor(task.status),
                //   labelStyle: const TextStyle(fontSize: 12),
                // ),
                Chip(
                  label: Text(task.priority),
                  backgroundColor: _getPriorityColor(task.priority),
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Due date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Due: ${task.dueDate?.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            const Spacer(),

            // Created By (bottom-left)
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
