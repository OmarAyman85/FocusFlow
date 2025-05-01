import '../entities/workspace.dart';

abstract class WorkspaceRepository {
  Future<void> createWorkspace(Workspace workspace);
  List<Workspace> getWorkspaces(); // or Stream if using Firebase
}
