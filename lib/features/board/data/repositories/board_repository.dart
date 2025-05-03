import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/board/data/sources/board_remote_data_source.dart';
import 'package:focusflow/features/board/domain/entities/board.dart';
import 'package:focusflow/features/board/domain/repositories/board_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class BoardRepositoryImpl implements BoardRepository {
  @override
  Future<void> createBoard(Board board) async {
    try {
      return await sl<BoardRemoteDataSource>().createBoard(board);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Board>> getBoards(String workspaceId) async {
    try {
      return await sl<BoardRemoteDataSource>().getBoards(workspaceId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> addBoardMember(
    String workspaceId,
    String boardId,
    Member member,
  ) async {
    try {
      return await sl<BoardRemoteDataSource>().addBoardMember(
        workspaceId,
        boardId,
        member,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
