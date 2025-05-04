import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class GetBoardCountUseCase {
  Future<int> call(String workspaceId) {
    return sl<WorkspaceRepository>().getBoardCount(workspaceId);
  }
}
