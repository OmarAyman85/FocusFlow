import 'package:focusflow/core/injection/injection_container.dart';

import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class CreateWorkspaceUseCase {
  Future<void> call(Workspace workspace) async {
    return sl<WorkspaceRepository>().createWorkspace(workspace);
  }
}
