import 'package:focusflow/features/workspace/domain/entities/workspace.dart';

abstract class WorkspaceRepository {
  Future<void> createWorkspace(Workspace workspace);
  Stream<List<Workspace>> getWorkspaces(String userId);
}
