import 'package:focusflow/features/task/data/models/task_model.dart';
import 'package:focusflow/features/task/data/sources/task_remote_data_source.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/domain/repositories/task_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<void> createTask({
    required String workspaceId,
    required String boardId,
    required TaskEntity task,
  }) async {
    final model = TaskModel.fromEntity(task);
    await sl<TaskRemoteDataSource>().createTask(
      workspaceId: workspaceId,
      boardId: boardId,
      task: model,
    );
  }

  @override
  Future<List<TaskEntity>> getTasks({
    required String workspaceId,
    required String boardId,
  }) async {
    final models = await sl<TaskRemoteDataSource>().getTasks(
      workspaceId: workspaceId,
      boardId: boardId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> deleteTask({
    required String workspaceId,
    required String boardId,
    required String taskId,
  }) async {
    await sl<TaskRemoteDataSource>().deleteTask(
      workspaceId: workspaceId,
      boardId: boardId,
      taskId: taskId,
    );
  }

  @override
  Future<void> updateTask({
    required String workspaceId,
    required String boardId,
    required TaskEntity task,
  }) async {
    final model = TaskModel.fromEntity(task);
    await sl<TaskRemoteDataSource>().updateTask(
      workspaceId: workspaceId,
      boardId: boardId,
      task: model,
    );
  }
}
