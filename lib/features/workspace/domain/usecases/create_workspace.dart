import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class CreateWorkspaceUseCase {
  final WorkspaceRepository repository;

  CreateWorkspaceUseCase(this.repository);

  Future<void> call(Workspace workspace) {
    return repository.createWorkspace(workspace);
  }
}
