import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/board/domain/repositories/board_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class AddMemberToBoardUseCase {
  Future<void> call(String workspaceId, String boardId, Member member) async {
    return sl<BoardRepository>().addBoardMember(workspaceId, boardId, member);
  }
}
