import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';

class GetWorkspacesUseCase {
  final WorkspaceRepository repository;

  GetWorkspacesUseCase({required this.repository});

  Stream<List<Workspace>> call(String userId) {
    return repository.getWorkspaces(userId);
  }
}
