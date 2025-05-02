import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/injection_container.dart';

class GetUsersUseCase {
  Future<List<Member>> call() async {
    return sl<WorkspaceRepository>().getUsers();
  }
}
