import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/constants/loading_spinner.dart';
import 'package:focusflow/core/utils/themes/app_pallete.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';
import 'package:focusflow/features/workspace/presentation/pages/workspace_form.dart';
import 'package:focusflow/features/workspace/presentation/services/add_member_dialog.dart';
import 'package:go_router/go_router.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

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
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
              ),
              itemCount: state.workspaces.length,
              itemBuilder: (context, index) {
                final workspace = state.workspaces[index];
                return Card(
                  elevation: 4,
                  color: AppPallete.gradient2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
                            child: const Text(
                              'Enter',
                              style: TextStyle(color: AppPallete.gradient1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed:
                                () => AddMemberDialog.openAddMemberDialog(
                                  context,
                                  workspace,
                                ),
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
                                  color: AppPallete.gradient1,
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
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WorkspaceForm(userId: state.user.uid),
                      ),
                    ),
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
