import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/features/task/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  Future<void> call({
    required String workspaceId,
    required String boardId,
    required String taskId,
  }) async {
    return await sl<TaskRepository>().deleteTask(
      workspaceId: workspaceId,
      boardId: boardId,
      taskId: taskId,
    );
  }
}
