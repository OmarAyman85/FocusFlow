import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:uuid/uuid.dart'; // Import for generating UUIDs

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
  int _workspaceNumberOfProjects = 0;

  void _submitForm(String userId, String userName) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      // Generate a unique ID for the new workspace
      String workspaceId = Uuid().v4(); // Using UUID to generate unique ID

      final newWorkspace = Workspace(
        id: workspaceId, // Assign the generated ID
        name: _workspaceName,
        description: _workspaceDescription,
        numberOfMembers: 1,
        numberOfProjects: _workspaceNumberOfProjects,
        createdById: userId,
        createdByName: userName,
        members: [Member(id: userId, name: userName)],
      );

      context.read<WorkspaceCubit>().addWorkspace(newWorkspace);
      Navigator.of(context).pop(); // Ensure correct navigation
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
            appBar: AppBar(title: const Text('Create Workspace')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _workspaceName = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _workspaceDescription = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Number of Projects',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _workspaceNumberOfProjects = int.tryParse(value!) ?? 0;
                      },
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
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
