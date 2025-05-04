import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/features/board/domain/entities/board.dart';
import 'package:focusflow/features/board/domain/repositories/board_repository.dart';

class UpdateBoardUseCase {
  Future<void> call(Board board) {
    return sl<BoardRepository>().updateBoard(board);
  }
}
