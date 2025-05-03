import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/domain/usecases/add_member_to_task_use_case.dart';
import 'package:focusflow/features/task/domain/usecases/create_task_use_case.dart';
import 'package:focusflow/features/task/domain/usecases/get_tasks_use_case.dart';
import 'package:focusflow/features/task/domain/usecases/get_users_use_case.dart';
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
      final users = await sl<GetTaskUsersUseCase>().call();
      return users;
    } catch (e) {
      emit(TaskError("Failed to load users: $e"));
      return Future.error("Failed to load users: $e");
    }
  }

  // Implement the addTaskMember functionality
  Future<void> addTaskMember({
    required String taskId,
    required String memberId,
  }) async {
    emit(TaskLoading());
    try {
      // Call the use case to add the member to the task
      await sl<AddTaskMemberUseCase>().call(taskId: taskId, memberId: memberId);

      // Reload the tasks after adding the member
      emit(TaskMemberAdded(taskId: taskId, memberId: memberId));
      await loadTasks(
        workspaceId: "workspaceId",
        boardId: "boardId",
      ); // You might need to pass workspaceId and boardId dynamically
    } catch (e) {
      emit(TaskError('Failed to add member to task: ${e.toString()}'));
    }
  }
}
