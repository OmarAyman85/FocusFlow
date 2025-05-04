import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/features/board/domain/repositories/board_repository.dart';

class DeleteBoardUseCase {
  Future<void> call(String workspaceId, String boardId) {
    return sl<BoardRepository>().deleteBoard(workspaceId, boardId);
  }
}
