import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';

class UpdateWorkspaceUseCase {
  Future<void> call(String workspaceId, Workspace updatedWorkspace) {
    return sl<WorkspaceRepository>().updateWorkspace(
      workspaceId,
      updatedWorkspace,
    );
  }
}
