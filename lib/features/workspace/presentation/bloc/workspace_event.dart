abstract class WorkspaceEvent {}

class LoadWorkspaces extends WorkspaceEvent {
  final String userId;
  LoadWorkspaces(this.userId);
}

class SubmitWorkspaceForm extends WorkspaceEvent {
  final String name;
  final String userId;

  SubmitWorkspaceForm({required this.name, required this.userId});
}
