import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/auth/presentation/widgets/sign_out_button.dart';
import 'package:go_router/go_router.dart'; // Import for navigation
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_state.dart';

class WorkspaceScreen extends StatelessWidget {
  final String userId;

  const WorkspaceScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Workspaces"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SignOutButton(),
          ),
        ],
      ),
      body: BlocBuilder<WorkspaceBloc, WorkspaceState>(
        builder: (context, state) {
          if (state is WorkspaceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkspaceLoaded) {
            return ListView.builder(
              itemCount: state.workspaces.length,
              itemBuilder: (context, index) {
                final ws = state.workspaces[index];
                return ListTile(
                  title: Text(ws.name),
                  subtitle: Text('Created by: ${ws.createdBy}'),
                );
              },
            );
          } else if (state is WorkspaceError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Create Workspace screen
          context.push('/create-workspace?uid=$userId');
        },
        tooltip: 'Create Workspace',
        child: const Icon(Icons.add),
      ),
    );
  }
}
