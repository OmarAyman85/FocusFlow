import '../entities/workspace.dart';

abstract class WorkspaceRepository {
  Future<List<Workspace>> getUserWorkspaces(String userId);

  Future<void> createWorkspace(Workspace workspace);
}
