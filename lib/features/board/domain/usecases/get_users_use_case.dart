import 'package:focusflow/features/board/domain/repositories/board_repository.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/injection_container.dart';

class GetBoardUsersUseCase {
  Future<List<Member>> call() async {
    return sl<BoardRepository>().getUsers();
  }
}
