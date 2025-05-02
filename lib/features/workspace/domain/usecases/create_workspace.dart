import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class CreateWorkspaceUseCase {
  final WorkspaceRepository repository;

  CreateWorkspaceUseCase({required this.repository});

  Future<void> call(Workspace workspace) async {
    return repository.createWorkspace(workspace);
  }
}
