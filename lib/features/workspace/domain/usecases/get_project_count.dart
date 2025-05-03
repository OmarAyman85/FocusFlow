// domain/usecases/get_project_count.dart
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/injection_container.dart';

class GetProjectCountUseCase {
  Future<int> call(String workspaceId) {
    return sl<WorkspaceRepository>().getProjectCount(workspaceId);
  }
}
