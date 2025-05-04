import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/features/board/domain/repositories/board_repository.dart';

class GetTaskCountUseCase {
  Future<int> call(String workspaceId, String boardId) {
    return sl<BoardRepository>().getTaskCount(workspaceId, boardId);
  }
}
