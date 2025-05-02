import 'package:focusflow/features/project/domain/repositories/project_repository.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/injection_container.dart';

class GetProjectUsersUseCase {
  Future<List<Member>> call() async {
    return sl<ProjectRepository>().getUsers();
  }
}
