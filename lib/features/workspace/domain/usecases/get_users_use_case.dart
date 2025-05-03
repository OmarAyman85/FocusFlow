import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class GetWorkspaceUsersUseCase {
  Future<List<Member>> call() async {
    return sl<WorkspaceRepository>().getUsers();
  }
}
