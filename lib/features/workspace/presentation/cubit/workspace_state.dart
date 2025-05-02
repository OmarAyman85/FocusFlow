// lib/features/workspace/application/workspace_state.dart
import '../../domain/entities/workspace.dart';

class WorkspaceState {
  final List<Workspace> workspaces;

  WorkspaceState({required this.workspaces});

  factory WorkspaceState.initial() => WorkspaceState(workspaces: []);

  WorkspaceState copyWith({List<Workspace>? workspaces}) {
    return WorkspaceState(workspaces: workspaces ?? this.workspaces);
  }
}