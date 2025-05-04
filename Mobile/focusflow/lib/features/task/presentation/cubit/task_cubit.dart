import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/core/services/user_service.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/domain/usecases/add_member_to_task_use_case.dart';
import 'package:focusflow/features/task/domain/usecases/create_task_use_case.dart';
import 'package:focusflow/features/task/domain/usecases/delete_task_use_case.dart';
import 'package:focusflow/features/task/domain/usecases/get_tasks_use_case.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  Future<void> loadTasks({
    required String workspaceId,
    required String boardId,
  }) async {
    emit(TaskLoading());
    try {
      final tasks = await sl<GetTasksUseCase>().call(
        workspaceId: workspaceId,
        boardId: boardId,
      );
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks: ${e.toString()}'));
    }
  }

  Future<void> createTask({
    required String workspaceId,
    required String boardId,
    required TaskEntity task,
  }) async {
    emit(TaskLoading());
    try {
      await sl<CreateTaskUseCase>().call(
        workspaceId: workspaceId,
        boardId: boardId,
        task: task,
      );
      await loadTasks(workspaceId: workspaceId, boardId: boardId);
    } catch (e) {
      emit(TaskError('Failed to create task: ${e.toString()}'));
    }
  }

  Future<List<Member>> getUsers() async {
    try {
      final users = await sl<UserService>().getUsers();
      return users;
    } catch (e) {
      emit(TaskError("Failed to load users: $e"));
      return Future.error("Failed to load users: $e");
    }
  }

  Future<void> addTaskMember({
    required String taskId,
    required String memberId,
  }) async {
    emit(TaskLoading());
    try {
      await sl<AddTaskMemberUseCase>().call(taskId: taskId, memberId: memberId);

      emit(TaskMemberAdded(taskId: taskId, memberId: memberId));
      await loadTasks(workspaceId: "workspaceId", boardId: "boardId");
    } catch (e) {
      emit(TaskError('Failed to add member to task: ${e.toString()}'));
    }
  }

  Future<void> deleteTask({
    required String workspaceId,
    required String boardId,
    required String taskId,
  }) async {
    emit(TaskLoading());
    try {
      await sl<DeleteTaskUseCase>().call(
        workspaceId: workspaceId,
        boardId: boardId,
        taskId: taskId,
      );
      await loadTasks(workspaceId: workspaceId, boardId: boardId);
      emit(TaskDeleted(taskId));
    } catch (e) {
      emit(TaskError('Failed to delete task: ${e.toString()}'));
    }
  }
}
