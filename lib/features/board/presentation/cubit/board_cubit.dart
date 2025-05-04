import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/core/services/user_service.dart';
import 'package:focusflow/features/board/domain/entities/board.dart';
import 'package:focusflow/features/board/domain/usecases/add_member_to_board_use_case.dart';
import 'package:focusflow/features/board/domain/usecases/create_board_use_case.dart';
import 'package:focusflow/features/board/domain/usecases/get_boards_use_case.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/features/board/domain/usecases/get_task_count.dart';
import 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardInitial());

  get boardRepository => null;

  void loadBoards(String workspaceId) async {
    emit(BoardLoading());
    try {
      final boards = await sl<GetBoardsUseCase>().call(workspaceId);

      final List<Board> enrichedBoards = [];

      for (final board in boards) {
        final taskCount = await sl<GetTaskCountUseCase>().call(
          workspaceId,
          board.id,
        );

        final enrichedBoard = Board(
          id: board.id,
          workspaceId: board.workspaceId,
          name: board.name,
          description: board.description,
          numberOfMembers: board.numberOfMembers,
          numberOfTasks: taskCount,
          createdById: board.createdById,
          createdByName: board.createdByName,
          members: board.members,
        );

        enrichedBoards.add(enrichedBoard);
      }

      emit(BoardLoaded(enrichedBoards));
    } catch (e) {
      emit(BoardError("Failed to load boards: $e"));
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
    return await sl<UserService>().getUsers();
  }

  Future<void> addBoardMember(
    String workspaceId,
    String boardId,
    Member member,
  ) async {
    await sl<AddMemberToBoardUseCase>().call(workspaceId, boardId, member);
    loadBoards(workspaceId);
  }
}
