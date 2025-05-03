import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/core/widgets/loading_spinner_widget.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:uuid/uuid.dart';

class WorkspaceForm extends StatefulWidget {
  final String userId;
  const WorkspaceForm({super.key, required this.userId});

  @override
  State<WorkspaceForm> createState() => _WorkspaceFormState();
}

class _WorkspaceFormState extends State<WorkspaceForm> {
  final _formKey = GlobalKey<FormState>();
  String _workspaceName = '';
  String _workspaceDescription = '';
  final int _workspacenumberOfBoards = 0;

  void _submitForm(String userId, String userName) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final newWorkspace = Workspace(
        id: const Uuid().v4(),
        name: _workspaceName,
        description: _workspaceDescription,
        numberOfMembers: 1,
        numberOfBoards: _workspacenumberOfBoards,
        createdById: userId,
        createdByName: userName,
        members: [Member(id: userId, name: userName)],
      );

      context.read<WorkspaceCubit>().createWorkspace(newWorkspace, userId);
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
            appBar: const MainAppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      label: 'Name',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _workspaceName = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    AppTextFormField(
                      label: 'Description',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _workspaceDescription = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submitForm(userId, userName),
                      child: const Text('Create Workspace'),
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
