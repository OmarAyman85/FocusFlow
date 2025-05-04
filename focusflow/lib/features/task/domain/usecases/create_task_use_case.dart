import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/domain/repositories/task_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class CreateTaskUseCase {
  Future<void> call({
    required String workspaceId,
    required String boardId,
    required TaskEntity task,
  }) async {
    return await sl<TaskRepository>().createTask(
      workspaceId: workspaceId,
      boardId: boardId,
      task: task,
    );
  }
}
