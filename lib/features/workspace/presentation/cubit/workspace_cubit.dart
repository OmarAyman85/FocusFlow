// lib/features/workspace/application/workspace_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'workspace_state.dart';
import '../../domain/entities/workspace.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit() : super(WorkspaceState.initial());

  void addWorkspace(
    String name,
    String description,
    int numberOfMembers,
    int numberOfProjects,
  ) {
    final updatedList = List<Workspace>.from(state.workspaces)..add(
      Workspace(
        name: name,
        description: description,
        numberOfMembers: numberOfMembers,
        numberOfProjects: numberOfProjects,
      ),
    );
    emit(state.copyWith(workspaces: updatedList));
  }
}
