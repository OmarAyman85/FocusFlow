import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/task/domain/repositories/task_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class GetTaskUsersUseCase {
  Future<List<Member>> call() async {
    return await sl<TaskRepository>().getUsers();
  }
}
