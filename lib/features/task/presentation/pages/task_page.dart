import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
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
      appBar: MainAppBar(),
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

                    // Handle list of user IDs
                    final assignedToNames = task.assignedTo
                        .map((id) => userMap[id] ?? id)
                        .join(', ');

                    final createdByName =
                        userMap[task.createdBy] ?? task.createdBy;

                    return Card(
                      margin: EdgeInsets.zero,
                      elevation: 3,
                      color: AppPallete.gradient2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Padding(
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
                                Text(
                                  'Due: ${task.dueDate}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Assigned to: $assignedToNames',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Created by: $createdByName',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to task detail page
                              },
                              child: const Text('More'),
                            ),
                          ),
                        ],
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
