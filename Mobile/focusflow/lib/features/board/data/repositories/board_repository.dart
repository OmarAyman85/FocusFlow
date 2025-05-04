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

  @override
  Future<int> getTaskCount(String workspaceId, String boardId) async {
    try {
      return await sl<BoardRemoteDataSource>().getTaskCount(
        workspaceId,
        boardId,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteBoard(String workspaceId, String boardId) async {
    try {
      return await sl<BoardRemoteDataSource>().deleteBoard(
        workspaceId,
        boardId,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> updateBoard(Board board) async {
    try {
      return await sl<BoardRemoteDataSource>().updateBoard(board);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
