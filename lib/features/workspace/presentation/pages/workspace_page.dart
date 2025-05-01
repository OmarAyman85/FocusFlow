import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';
import 'workspace_form.dart';

class WorkspacePage extends StatelessWidget {
  const WorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FocusFlow')),
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
    );
  }
}
