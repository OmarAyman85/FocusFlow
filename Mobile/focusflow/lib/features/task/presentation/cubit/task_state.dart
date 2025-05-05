import 'package:equatable/equatable.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskDeleted extends TaskState {
  final String taskId;

  const TaskDeleted(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class TaskUpdated extends TaskState {
  final TaskEntity task;

  const TaskUpdated(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskMemberAdded extends TaskState {
  final String taskId;
  final String memberId;

  const TaskMemberAdded({required this.taskId, required this.memberId});

  @override
  List<Object?> get props => [taskId, memberId];
}
