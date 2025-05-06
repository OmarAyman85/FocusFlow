import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask({
    required String workspaceId,
    required String boardId,
    required TaskEntity task,
  });

  Future<List<TaskEntity>> getTasks({
    required String workspaceId,
    required String boardId,
  });

  Future<void> deleteTask({
    required String workspaceId,
    required String boardId,
    required String taskId,
  });

  Future<void> updateTask({
    required String workspaceId,
    required String boardId,
    required TaskEntity task,
  });
}
