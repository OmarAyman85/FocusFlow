import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/domain/repositories/task_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class GetTasksUseCase {
  Future<List<TaskEntity>> call({
    required String workspaceId,
    required String boardId,
  }) async {
    return await sl<TaskRepository>().getTasks(
      workspaceId: workspaceId,
      boardId: boardId,
    );
  }
}
