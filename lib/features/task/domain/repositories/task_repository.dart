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

  Future<void> addMemberToTask({
    required String taskId,
    required String memberId,
  });
}
