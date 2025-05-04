import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/board/domain/entities/board.dart';

abstract class BoardRepository {
  Future<void> createBoard(Board board);
  Future<List<Board>> getBoards(String workspaceId);
  Future<void> addBoardMember(
    String workspaceId,
    String boardId,
    Member member,
  );
  Future<int> getTaskCount(String workspaceId, String boardId);

  Future<void> deleteBoard(String workspaceId, String boardId);

  Future<void> updateBoard(Board board);
}
