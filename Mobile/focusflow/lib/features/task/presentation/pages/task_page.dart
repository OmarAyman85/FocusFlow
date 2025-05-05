import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/loading_spinner_widget.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:focusflow/features/task/presentation/cubit/task_state.dart';
import 'package:focusflow/features/task/presentation/pages/gantt_chart_page.dart';
import 'package:focusflow/features/task/presentation/services/task_user_helper.dart';
import 'package:focusflow/features/task/presentation/widgets/task_card.dart';
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
    userIdToNameMap = TaskUserHelper.getUserIdToNameMap(context);

    Future.microtask(() {
      context.read<TaskCubit>().loadTasks(
        workspaceId: widget.workspaceId,
        boardId: widget.boardId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.timeline),
            onPressed: () {
              // You need to get tasks from the state here
              final state = context.read<TaskCubit>().state;
              if (state is TaskLoaded) {
                final tasks = state.tasks;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            GanttChartPage(tasks: tasks), // Now passing tasks
                  ),
                );
              }
            },
          ),
        ],
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
                return const LoadingSpinnerWidget();
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
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
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
                      workspaceId: widget.workspaceId,
                      boardId: widget.boardId,
                    );
                  },
                );
              }

              return const SizedBox.shrink();
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
