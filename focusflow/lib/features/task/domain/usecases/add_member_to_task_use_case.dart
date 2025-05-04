import 'package:focusflow/features/task/domain/repositories/task_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class AddTaskMemberUseCase {
  Future<void> call({required String taskId, required String memberId}) async {
    return await sl<TaskRepository>().addMemberToTask(
      taskId: taskId,
      memberId: memberId,
    );
  }
}
