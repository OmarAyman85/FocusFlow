import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class GetUserWorkspaces {
  final WorkspaceRepository repository;

  GetUserWorkspaces(this.repository);

  Future<List<Workspace>> call(String userId) {
    return repository.getUserWorkspaces(userId);
  }
}
