import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  Future<void> call({
    required String workspaceId,
    required String boardId,
    required TaskEntity task,
  }) async {
    return await sl<TaskRepository>().updateTask(
      workspaceId: workspaceId,
      boardId: boardId,
      task: task,
    );
  }
}
