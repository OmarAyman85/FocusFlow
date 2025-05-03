import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/constants/loading_spinner.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/widgets/workspace_field.dart';
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
  int _workspacenumberOfBoards = 0;

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
            appBar: AppBar(
              title: const Text('FocusFlow'),
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
                      label: 'Name',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _workspaceName = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    LabeledTextFormField(
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
