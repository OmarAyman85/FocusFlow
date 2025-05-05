import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/loading_spinner_widget.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:focusflow/features/task/presentation/cubit/task_state.dart';
import 'package:focusflow/features/task/presentation/pages/gantt_chart_page.dart';
import 'package:focusflow/features/task/presentation/services/task_user_helper.dart';
import 'package:focusflow/features/task/presentation/widgets/task_card.dart';
import 'package:go_router/go_router.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';

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

    // Load tasks when the page is initialized
    Future.microtask(() {
      context.read<TaskCubit>().loadTasks(
        workspaceId: widget.workspaceId,
        boardId: widget.boardId,
      );
    });
  }

  void _onTaskDropped(
    TaskEntity task,
    String newStatus,
    Map<String, String> userMap,
  ) {
    final updatedTask = task.copyWith(status: newStatus);

    // Update task and then reload tasks
    context.read<TaskCubit>().updateTask(
      workspaceId: widget.workspaceId,
      boardId: widget.boardId,
      task: updatedTask,
    );
  }

  List<TaskEntity> _filterTasks(List<TaskEntity> tasks, String status) {
    return tasks.where((t) => t.status == status).toList();
  }

  Widget _buildColumn(
    String title,
    String status,
    List<TaskEntity> tasks,
    Map<String, String> userMap,
  ) {
    return Expanded(
      child: DragTarget<TaskEntity>(
        onWillAccept: (_) => true,
        onAccept: (task) => _onTaskDropped(task, status, userMap),
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.gradient2,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final createdByName =
                          userMap[task.createdBy] ?? task.createdBy;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LongPressDraggable<TaskEntity>(
                          data: task,
                          feedback: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(12),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 250),
                              child: TaskCard(
                                task: task,
                                userMap: userMap,
                                createdByName: createdByName,
                                workspaceId: widget.workspaceId,
                                boardId: widget.boardId,
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.5,
                            child: TaskCard(
                              task: task,
                              userMap: userMap,
                              createdByName: createdByName,
                              workspaceId: widget.workspaceId,
                              boardId: widget.boardId,
                            ),
                          ),
                          child: TaskCard(
                            task: task,
                            userMap: userMap,
                            createdByName: createdByName,
                            workspaceId: widget.workspaceId,
                            boardId: widget.boardId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: 'Tasks'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  final state = context.read<TaskCubit>().state;
                  if (state is TaskLoaded) {
                    final tasks = state.tasks;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GanttChartPage(tasks: tasks),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.grey,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.timeline),
                    SizedBox(width: 8),
                    Text(
                      'View in chart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<Map<String, String>>(
              future: userIdToNameMap,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingSpinnerWidget());
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

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildColumn(
                            "To-Do",
                            "todo",
                            _filterTasks(tasks, "todo"),
                            userMap,
                          ),
                          _buildColumn(
                            "In Progress",
                            "in_progress",
                            _filterTasks(tasks, "in_progress"),
                            userMap,
                          ),
                          _buildColumn(
                            "Done",
                            "done",
                            _filterTasks(tasks, "done"),
                            userMap,
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ],
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
