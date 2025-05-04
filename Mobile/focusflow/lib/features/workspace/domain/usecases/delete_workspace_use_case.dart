import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';

class DeleteWorkspaceUseCase {
  Future<void> call(String workspaceId) async {
    return sl<WorkspaceRepository>().deleteWorkspace(workspaceId);
  }
}
