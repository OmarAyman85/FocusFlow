import 'package:focusflow/features/board/domain/entities/member.dart';

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

  Future<List<Member>> getUsers();

  Future<void> addMemberToTask({
    required String taskId,
    required String memberId,
  });
}
