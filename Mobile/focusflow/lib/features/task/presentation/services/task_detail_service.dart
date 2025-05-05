import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';

class TaskDetailService {
  final TaskCubit taskCubit;

  TaskDetailService(this.taskCubit);

  Future<void> deleteTask(String workspaceId, String boardId, String taskId) async {
    await taskCubit.deleteTask(
      workspaceId: workspaceId,
      boardId: boardId,
      taskId: taskId,
    );
    await taskCubit.loadTasks(
      workspaceId: workspaceId,
      boardId: boardId,
    );
  }
}
