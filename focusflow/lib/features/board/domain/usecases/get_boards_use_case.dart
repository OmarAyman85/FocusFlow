import 'package:focusflow/features/board/domain/entities/board.dart';
import 'package:focusflow/features/board/domain/repositories/board_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class GetBoardsUseCase {
  Future<List<Board>> call(String workspaceId) {
    return sl<BoardRepository>().getBoards(workspaceId);
  }
}
