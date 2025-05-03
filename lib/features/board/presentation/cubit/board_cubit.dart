import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/board/domain/entities/board.dart';
import 'package:focusflow/features/board/domain/usecases/add_member_to_board_use_case.dart';
import 'package:focusflow/features/board/domain/usecases/create_board_use_case.dart';
import 'package:focusflow/features/board/domain/usecases/get_boards_use_case.dart';
import 'package:focusflow/features/board/domain/usecases/get_users_use_case.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardInitial());

  get boardRepository => null;

  void loadBoards(String workspaceId) async {
    emit(BoardLoading());
    try {
      final boards = await sl<GetBoardsUseCase>().call(workspaceId);
      emit(BoardLoaded(boards));
    } catch (e) {
      emit(BoardError(e.toString()));
    }
  }

  void createBoard(Board board) async {
    try {
      await sl<CreateBoardUseCase>().call(board);
      loadBoards(board.workspaceId);
    } catch (e) {
      emit(BoardError(e.toString()));
    }
  }

  Future<List<Member>> getUsers() async {
    return await sl<GetBoardUsersUseCase>().call();
  }

  Future<void> addBoardMember(
    String workspaceId,
    String boardId,
    Member member,
  ) async {
    await sl<AddMemberToBoardUseCase>().call(workspaceId, boardId, member);
    loadBoards(workspaceId); // Refresh boards
  }
}
