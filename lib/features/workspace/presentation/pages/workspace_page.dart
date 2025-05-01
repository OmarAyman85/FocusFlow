import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/utils/constants/loading_spinner.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';
import 'package:go_router/go_router.dart';
import 'workspace_form.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

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
                Workspace workspace = state.workspaces[index];
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
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            child: const Text('Enter'),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 35),
                            Text(
                              workspace.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              workspace.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final userId = 'dummy-user-id'; // Replace with real ID
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => WorkspaceForm(userId: userId)),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
