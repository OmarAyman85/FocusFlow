import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class GetWorkspacesUseCase {
  Stream<List<Workspace>> call(String userId) {
    return sl<WorkspaceRepository>().getWorkspaces(userId);
  }
}
