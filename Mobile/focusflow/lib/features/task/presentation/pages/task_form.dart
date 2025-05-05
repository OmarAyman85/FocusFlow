import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:focusflow/features/task/presentation/widgets/assigned_members_widget.dart';
import 'package:focusflow/features/task/presentation/widgets/due_date_picker.dart';
import 'package:focusflow/features/task/presentation/widgets/priority_dropdown.dart';
import 'package:go_router/go_router.dart';
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
  final List<String> _assignedTo = [];

  String _taskTitle = '';
  String _taskDescription = '';
  String _priority = 'Medium';
  final String _status = 'todo';
  DateTime? _dueDate;

  Future<void> _submitForm(String userId) async {
    if (!_formKey.currentState!.validate()) return;
    if (_assignedTo.isEmpty || _dueDate == null) {
      final msg =
          _assignedTo.isEmpty
              ? 'Please assign at least one member'
              : 'Please select a due date';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }

    _formKey.currentState!.save();

    final task = TaskEntity(
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
      task: task,
    );

    if (mounted) GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) return const SizedBox();

        final userId = state.user.uid;

        return Scaffold(
          appBar: const MainAppBar(title: 'Create Task'),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  AppTextFormField(
                    label: 'Task Title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title required';
                      }
                      if (value.trim().length < 3) return 'Min 3 characters';
                      if (value.trim().length > 50) return 'Max 50 characters';
                      return null;
                    },
                    onSaved: (value) => _taskTitle = value!.trim(),
                  ),
                  const SizedBox(height: 20),
                  AppTextFormField(
                    label: 'Task Description',
                    validator:
                        (value) =>
                            (value == null || value.trim().length < 10)
                                ? 'Description must be at least 10 characters'
                                : null,
                    onSaved: (value) => _taskDescription = value!.trim(),
                  ),
                  const SizedBox(height: 20),
                  AssignedMembersWidget(
                    assignedTo: _assignedTo,
                    onMemberAdded:
                        (name) => setState(() => _assignedTo.add(name)),
                    onMemberRemoved:
                        (name) => setState(() => _assignedTo.remove(name)),
                    boardId: widget.boardId,
                    workspaceId: widget.workspaceId
                  ),
                  const SizedBox(height: 20),
                  PriorityDropdown(
                    currentPriority: _priority,
                    onChanged: (value) => setState(() => _priority = value),
                  ),
                  const SizedBox(height: 20),
                  DueDatePicker(
                    selectedDate: _dueDate,
                    onPickDate: (picked) => setState(() => _dueDate = picked),
                  ),
                  const SizedBox(height: 30),
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
                      onPressed: () => _submitForm(userId),
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
        );
      },
    );
  }
}
