import 'package:focusflow/features/board/domain/entities/board.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';

abstract class BoardRepository {
  Future<void> createBoard(Board board);
  Future<List<Board>> getBoards(String workspaceId);
  Future<List<Member>> getUsers();
  Future<void> addBoardMember(
    String workspaceId,
    String boardId,
    Member member,
  );
}
