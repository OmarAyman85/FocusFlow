import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/constants/loading_spinner.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/project/domain/entities/member.dart';
import 'package:focusflow/features/project/domain/entities/project.dart';
import 'package:focusflow/features/project/presentation/cubit/project_cubit.dart';
import 'package:focusflow/features/workspace/presentation/widgets/workspace_field.dart';
import 'package:uuid/uuid.dart';

class ProjectForm extends StatefulWidget {
  final String workspaceId;
  const ProjectForm({super.key, required this.workspaceId});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  String _projectName = '';
  String _projectDescription = '';

  void _submitForm(String userId, String userName) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final newProject = Project(
        id: const Uuid().v4(),
        name: _projectName,
        description: _projectDescription,
        numberOfMembers: 1,
        numberOfBoards: 0, 
        workspaceId: widget.workspaceId,
        createdById: userId,
        createdByName: userName,
        members: [Member(id: userId, name: userName)],
      );

      context.read<ProjectCubit>().createProject(newProject);
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
              title: const Text('Create Project'),
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
                      label: 'Project Name',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _projectName = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    LabeledTextFormField(
                      label: 'Project Description',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _projectDescription = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    // Add a member selection widget here to populate the members list
                    // You would want to provide a way for the user to select members and add them to _members
                    ElevatedButton(
                      onPressed: () => _submitForm(userId, userName),
                      child: const Text('Create Project'),
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
