import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/constants/loading_spinner.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';
import 'package:focusflow/features/workspace/presentation/pages/workspace_form.dart'; // Ensure this import exists
import 'package:go_router/go_router.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  void _openAddMemberDialog(BuildContext context, Workspace workspace) {
    final memberIdController = TextEditingController();
    final memberNameController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Add Member"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: memberIdController,
                  decoration: const InputDecoration(labelText: "Member ID"),
                ),
                TextField(
                  controller: memberNameController,
                  decoration: const InputDecoration(labelText: "Member Name"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final id = memberIdController.text.trim();
                  final name = memberNameController.text.trim();
                  if (id.isNotEmpty && name.isNotEmpty) {
                    context.read<WorkspaceCubit>().addMember(
                      workspace.id,
                      Member(id: id, name: name),
                    );
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _navigateToCreateWorkspace(BuildContext context, String userId) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => WorkspaceForm(userId: userId)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          GoRouter.of(context).go('/signin');
        } else if (state is AuthAuthenticated) {
          context.read<WorkspaceCubit>().loadUserWorkspaces(state.user.uid);
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
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
        body: BlocBuilder<WorkspaceCubit, WorkspaceState>(
          builder: (context, state) {
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              itemCount: state.workspaces.length,
              itemBuilder: (context, index) {
                final workspace = state.workspaces[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Enter'),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed:
                                () => _openAddMemberDialog(context, workspace),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workspace.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                workspace.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Projects: ${workspace.numberOfProjects}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                'Members: ${workspace.numberOfMembers}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                'Created by: ${workspace.createdByName}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return FloatingActionButton(
                onPressed:
                    () => _navigateToCreateWorkspace(context, state.user.uid),
                child: const Icon(Icons.add),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
