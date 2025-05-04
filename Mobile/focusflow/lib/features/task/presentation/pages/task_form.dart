import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

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
  final List<String> _assignedTo = [];
  String _status = 'Not Started';
  String _priority = 'Medium';
  DateTime? _dueDate;

  Future<void> _submitForm(String userId, String userName) async {
    // First, validate the form fields
    if (_formKey.currentState?.validate() ?? false) {
      // Then validate custom fields not inside the form: assigned members and due date
      if (_assignedTo.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please assign at least one member')),
        );
        return;
      }

      if (_dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a due date')),
        );
        return;
      }

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

      await context.read<TaskCubit>().createTask(
        workspaceId: widget.workspaceId,
        boardId: widget.boardId,
        task: newTask,
      );

      if (mounted) {
        GoRouter.of(context).pop();
      }
    }
  }

  void _openAddMemberDialog() async {
    final users = await context.read<TaskCubit>().getUsers();
    final selectedUser = await showDialog<Member>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Add Member to Task"),
            content: DropdownButton<Member>(
              hint: const Text("Select a User"),
              isExpanded: true,
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
          ),
    );

    if (selectedUser != null && !_assignedTo.contains(selectedUser.name)) {
      setState(() {
        _assignedTo.add(selectedUser.name);
      });
    }
  }

  Future<void> _pickDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFormField(
                        label: 'Task Title',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Task title is required';
                          }
                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          if (value.trim().length > 50) {
                            return 'Title must be under 50 characters';
                          }
                          return null;
                        },
                        onSaved: (value) => _taskTitle = value!.trim(),
                      ),
                      const SizedBox(height: 20),
                      AppTextFormField(
                        label: 'Task Description',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Description is required';
                          }
                          if (value.trim().length < 10) {
                            return 'Description must be at least 10 characters';
                          }
                          return null;
                        },
                        onSaved: (value) => _taskDescription = value!.trim(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Assigned Members'),
                          IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: _openAddMemberDialog,
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8.0,
                        children:
                            _assignedTo
                                .map(
                                  (name) => Chip(
                                    label: Text(name),
                                    onDeleted: () {
                                      setState(() {
                                        _assignedTo.remove(name);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _priority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                        ),
                        onChanged:
                            (newValue) => setState(() => _priority = newValue!),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                        items: const [
                          DropdownMenuItem(value: 'Low', child: Text('Low')),
                          DropdownMenuItem(
                            value: 'Medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(value: 'High', child: Text('High')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text('Due Date:'),
                          const SizedBox(width: 12),
                          Text(
                            _dueDate == null
                                ? 'None'
                                : DateFormat('yyyy-MM-dd').format(_dueDate!),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _pickDueDate,
                            style: TextButton.styleFrom(
                              foregroundColor: AppPallete.gradient1,
                            ),
                            child: const Text('Pick Date'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Attachments (optional)'),
                          IconButton(
                            icon: const Icon(Icons.attach_file),
                            onPressed: () {
                              // TODO: Handle attachments
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _submitForm(userId, userName),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.backgroundColor,
                            foregroundColor: AppPallete.gradient1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Save Task'),
                        ),
                      ),
                    ],
                  ),
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
