import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
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
  List<String> _assignedTo = []; // This will store user names now
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
        assignedTo: _assignedTo, // Now it's a list of names
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

  void _openAddMemberDialog() async {
    final users = await context.read<TaskCubit>().getUsers();
    final selectedUser = await showDialog<Member>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Add Member to Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<Member>(
                  hint: const Text("Select a User"),
                  onChanged: (Member? user) {
                    Navigator.of(ctx).pop(user);
                  },
                  items:
                      users.map((user) {
                        return DropdownMenuItem<Member>(
                          value: user,
                          child: Text(user.name),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
    );

    if (selectedUser != null) {
      setState(() {
        _assignedTo.add(selectedUser.name); // Add the user's name
      });
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
            appBar: MainAppBar(title: 'Create Task'),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      label: 'Task Title',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _taskTitle = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    AppTextFormField(
                      label: 'Task Description',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _taskDescription = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Assigned To (Click to add)',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _openAddMemberDialog,
                        ),
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _assignedTo.join(
                          ', ',
                        ), // Show names instead of IDs
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _status,
                      onChanged:
                          (newValue) => setState(() {
                            _status = newValue!;
                          }),
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
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submitForm(userId, userName),
                      child: const Text('Save Task'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
