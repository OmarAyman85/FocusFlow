// features/workspace/presentation/widgets/workspace_form_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/widgets/workspace_submit_button.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class WorkspaceFormFields extends StatefulWidget {
  final String userId;
  final String userName;

  const WorkspaceFormFields({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<WorkspaceFormFields> createState() => _WorkspaceFormFieldsState();
}

class _WorkspaceFormFieldsState extends State<WorkspaceFormFields> {
  final _formKey = GlobalKey<FormState>();
  String _workspaceName = '';
  String _workspaceDescription = '';
  final int _workspacenumberOfBoards = 0;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final newWorkspace = Workspace(
        id: const Uuid().v4(),
        name: _workspaceName,
        description: _workspaceDescription,
        numberOfMembers: 1,
        numberOfBoards: _workspacenumberOfBoards,
        createdById: widget.userId,
        createdByName: widget.userName,
        members: [Member(id: widget.userId, name: widget.userName)],
      );

      context.read<WorkspaceCubit>().createWorkspace(
        newWorkspace,
        widget.userId,
      );
      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextFormField(
              label: 'Workspace Name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Workspace name is required';
                }
                if (value.trim().length < 3) {
                  return 'Name must be at least 3 characters';
                }
                if (value.trim().length > 50) {
                  return 'Name must be under 50 characters';
                }
                return null;
              },
              onSaved: (value) => _workspaceName = value ?? '',
            ),
            const SizedBox(height: 20),
            AppTextFormField(
              label: 'Workspace Description',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                if (value.trim().length < 10) {
                  return 'Description must be at least 10 characters';
                }
                return null;
              },
              onSaved: (value) => _workspaceDescription = value ?? '',
            ),
            const SizedBox(height: 20),
            WorkspaceSubmitButton(onPressed: _submitForm),
          ],
        ),
      ),
    );
  }
}
