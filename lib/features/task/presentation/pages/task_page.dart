import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/themes/app_pallete.dart';
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
      return {}; // fallback to empty map if error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => GoRouter.of(context).pop('task_added'),
        ),
      ),
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

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    // Handle list of user IDs
                    final assignedToNames = task.assignedTo
                        .map((id) => userMap[id] ?? id)
                        .join(', ');

                    final createdByName =
                        userMap[task.createdBy] ?? task.createdBy;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      color: AppPallete.gradient2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.gradient1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Due: ${task.dueDate}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Assigned to: $assignedToNames',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Created by: $createdByName',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to task detail page
                              },
                              child: const Text('Moreee'),
                            ),
                          ],
                        ),
                      ),
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
