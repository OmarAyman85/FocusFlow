import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/constants/loading_spinner.dart';
import 'package:focusflow/core/utils/themes/app_pallete.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:focusflow/features/task/presentation/cubit/task_state.dart';
import 'package:focusflow/features/task/presentation/services/add_member_dialogue_tasks.dart';
import 'package:go_router/go_router.dart';

class TaskPage extends StatefulWidget {
  final String workspaceId;
  final String boardId;

  const TaskPage({super.key, required this.workspaceId, required this.boardId});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    // Delay ensures context is fully initialized before use
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
        leading: BackButton(
          onPressed: () => GoRouter.of(context).pop('task_added'),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: LoadingSpinnerWidget(),
                );
              } else if (state is AuthAuthenticated) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') {
                        context.read<AuthBloc>().add(SignOutRequested());
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'user_name',
                          child: Text('Name: ${state.user.name}'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ];
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Text(
                        state.user.name[0],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 3,
                  color: AppPallete.gradient2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task Title
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.gradient1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Task description
                        Text(
                          task.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Info row
                        Row(
                          children: [
                            Text(
                              'Due: ${task.dueDate}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Assigned to: ${task.assignedTo}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Created by: ${task.createdBy}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.person_add),
                              onPressed: () {
                                // Pass the whole task object instead of just the id
                                AddMemberDialog.openAddMemberDialog(
                                  context,
                                  task,
                                );
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // TODO : Implement task details page
                              },
                              child: const Text('Moreee'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final workspaceId = widget.workspaceId;
          final boardId = widget.boardId;
          GoRouter.of(
            context,
          ).push('/workspace/$workspaceId/board/$boardId/task-form');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
