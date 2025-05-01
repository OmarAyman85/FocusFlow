import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class CreateWorkspace {
  final WorkspaceRepository repository;

  CreateWorkspace(this.repository);

  Future<void> call(Workspace workspace) {
    return repository.createWorkspace(workspace);
  }
}
