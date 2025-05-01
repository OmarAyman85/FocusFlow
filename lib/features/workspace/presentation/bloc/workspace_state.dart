import '../../domain/entities/workspace.dart';

abstract class WorkspaceState {}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class CreateWorkspaceSuccess extends WorkspaceState {}

class WorkspaceLoaded extends WorkspaceState {
  final List<Workspace> workspaces;
  WorkspaceLoaded(this.workspaces);
}

class WorkspaceError extends WorkspaceState {
  final String message;
  WorkspaceError(this.message);
}
