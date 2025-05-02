import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/create_workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_workspace_use_case.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';

// workspace_cubit.dart
class WorkspaceCubit extends Cubit<WorkspaceState> {
  final CreateWorkspaceUseCase createWorkspaceUseCase;
  final GetWorkspacesUseCase getWorkspacesUseCase;

  WorkspaceCubit({
    required this.createWorkspaceUseCase,
    required this.getWorkspacesUseCase,
  }) : super(WorkspaceState.initial());

  void loadUserWorkspaces(String userId) {
    getWorkspacesUseCase(userId).listen((workspaces) {
      emit(state.copyWith(workspaces: workspaces));
    });
  }

  Future<void> addWorkspace(Workspace workspace) async {
    await createWorkspaceUseCase(workspace);
  }
}
