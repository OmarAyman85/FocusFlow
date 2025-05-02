import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/project_cubit.dart';
import '../cubit/project_state.dart';

class ProjectPage extends StatefulWidget {
  final String workspaceId;

  const ProjectPage({super.key, required this.workspaceId});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  void initState() {
    super.initState();
    // Delay ensures context is fully initialized before use
    Future.microtask(() {
      context.read<ProjectCubit>().loadProjects(widget.workspaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Projects:')),
      body: BlocBuilder<ProjectCubit, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectLoaded) {
            return ListView.builder(
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return ListTile(
                  title: Text(project.name),
                  subtitle: Text(project.description),
                );
              },
            );
          } else if (state is ProjectError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement adding a new project
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
