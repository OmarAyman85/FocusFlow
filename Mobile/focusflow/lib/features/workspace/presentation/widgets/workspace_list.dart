import 'package:flutter/material.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/widgets/user_header.dart';
import 'package:focusflow/features/workspace/presentation/widgets/workspace_card.dart';

class WorkspaceList extends StatelessWidget {
  final String username;
  final List<Workspace> workspaces;

  const WorkspaceList({
    super.key,
    required this.username,
    required this.workspaces,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 30),
          UserHeader(username: username),
          const SizedBox(height: 40),
          const Text('Your Workspaces', style: TextStyle(fontSize: 25)),
          const SizedBox(height: 20),
          ...workspaces.map((workspace) => WorkspaceCard(workspace: workspace)),
        ],
      ),
    );
  }
}
