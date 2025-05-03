import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/constants/loading_spinner.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:focusflow/features/workspace/presentation/widgets/workspace_field.dart';
import 'package:uuid/uuid.dart';

class TaskForm extends StatefulWidget {
  final String workspaceId;
  final String boardId;
  const TaskForm({super.key, required this.workspaceId, required this.boardId});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  String _taskTitle = '';
  String _taskDescription = '';
  List<String> _assignedTo = [];
  String _status = 'Not Started'; // Default status
  String _priority = 'Medium'; // Default priority
  DateTime? _dueDate;

  void _submitForm(String userId, String userName) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final newTask = TaskEntity(
        id: const Uuid().v4(),
        title: _taskTitle,
        description: _taskDescription,
        assignedTo: _assignedTo,
        status: _status,
        priority: _priority,
        dueDate: _dueDate,
        createdAt: DateTime.now(),
        createdBy: userId,
        attachments: [],
      );

      context.read<TaskCubit>().createTask(
        workspaceId: widget.workspaceId,
        boardId: widget.boardId,
        task: newTask,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final userId = state.user.uid;
          final userName = state.user.name;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Create Task'),
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
                          itemBuilder:
                              (_) => [
                                PopupMenuItem(
                                  value: 'user_name',
                                  child: Text('Name: ${state.user.name}'),
                                ),
                                const PopupMenuItem(
                                  value: 'logout',
                                  child: Text('Logout'),
                                ),
                              ],
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    LabeledTextFormField(
                      label: 'Task Title',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _taskTitle = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    LabeledTextFormField(
                      label: 'Task Description',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _taskDescription = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    LabeledTextFormField(
                      label: 'Assigned To (Comma separated)',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) {
                        _assignedTo = value?.split(',') ?? [];
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _status,
                      onChanged: (newValue) {
                        setState(() {
                          _status = newValue ?? 'Not Started';
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'Not Started',
                          child: Text('Not Started'),
                        ),
                        DropdownMenuItem(
                          value: 'In Progress',
                          child: Text('In Progress'),
                        ),
                        DropdownMenuItem(
                          value: 'Completed',
                          child: Text('Completed'),
                        ),
                      ],
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _priority,
                      onChanged: (newValue) {
                        setState(() {
                          _priority = newValue ?? 'Medium';
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                        DropdownMenuItem(
                          value: 'Medium',
                          child: Text('Medium'),
                        ),
                        DropdownMenuItem(value: 'High', child: Text('High')),
                      ],
                      decoration: const InputDecoration(labelText: 'Priority'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Due Date (yyyy-MM-dd)',
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        try {
                          _dueDate = DateTime.parse(value);
                        } catch (e) {
                          return 'Invalid date format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submitForm(userId, userName),
                      child: const Text('Create Task'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return LoadingSpinnerWidget();
        }
      },
    );
  }
}
