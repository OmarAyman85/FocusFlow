import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/constants/loading_spinner.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:go_router/go_router.dart';

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
  int _workspaceNumberOfMembers = 0;
  int _workspaceNumberOfProjects = 0;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      context.read<WorkspaceCubit>().addWorkspace(
        _workspaceName,
        _workspaceDescription,
        _workspaceNumberOfMembers,
        _workspaceNumberOfProjects,
      );
      Navigator.of(context).pop(); // Return to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          GoRouter.of(context).go('/signin');
        }
      },
      child: Scaffold(
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
                } else if (state is AuthError) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.error),
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
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Workspace Name',
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter a name'
                              : null,
                  onSaved: (value) => _workspaceName = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Workspace Description',
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter a description'
                              : null,
                  onSaved: (value) => _workspaceDescription = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Workspace Number of Members',
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter a number'
                              : null,
                  onSaved:
                      (value) => _workspaceNumberOfMembers = int.parse(value!),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Workspace Number of Projects',
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter a number'
                              : null,
                  onSaved:
                      (value) => _workspaceNumberOfProjects = int.parse(value!),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Create Workspace'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
