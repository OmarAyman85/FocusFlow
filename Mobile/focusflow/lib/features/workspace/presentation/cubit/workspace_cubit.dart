import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/core/services/user_service.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/add_member_to_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/create_workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/delete_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_board_count.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/update_workspace_use_case.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit() : super(WorkspaceInitial());

  Future<void> loadWorkspaces(String userId) async {
    emit(WorkspaceLoading());
    try {
      final stream = sl<GetWorkspacesUseCase>().call(userId);

      stream.listen(
        (workspaces) async {
          final List<Workspace> enrichedWorkspaces = [];

          for (final workspace in workspaces) {
            final count = await sl<GetBoardCountUseCase>().call(workspace.id);
            enrichedWorkspaces.add(workspace.copyWith(numberOfBoards: count));
          }

          emit(WorkspaceLoaded(enrichedWorkspaces));
        },
        onError: (e) {
          emit(WorkspaceError("Failed to load workspaces: $e"));
        },
      );
    } catch (e) {
      emit(WorkspaceError("Unexpected error: $e"));
    }
  }

  Future<void> createWorkspace(Workspace workspace, String userId) async {
    try {
      await sl<CreateWorkspaceUseCase>().call(workspace);
      loadWorkspaces(userId);
    } catch (e) {
      emit(WorkspaceError("Workspace creation failed: $e"));
    }
  }

  Future<List<Member>> getUsers() async {
    try {
      return await sl<UserService>().getUsers();
    } catch (e) {
      emit(WorkspaceError("Failed to load users: $e"));
      return [];
    }
  }

  Future<void> addWorkspaceMember(
    String workspaceId,
    Member member,
    String userId,
  ) async {
    try {
      await sl<AddMemberToWorkspaceUseCase>().call(workspaceId, member);
      loadWorkspaces(userId);
    } catch (e) {
      emit(WorkspaceError("Failed to add member: $e"));
    }
  }

  Future<void> deleteWorkspace(String workspaceId, String userId) async {
    try {
      await sl<DeleteWorkspaceUseCase>().call(workspaceId);
      loadWorkspaces(userId);
    } catch (e) {
      emit(WorkspaceError("Failed to delete workspace: $e"));
    }
  }

  Future<void> updateWorkspace(
    String workspaceId,
    Workspace updatedWorkspace,
    String userId,
  ) async {
    try {
      await sl<UpdateWorkspaceUseCase>().call(workspaceId, updatedWorkspace);
      loadWorkspaces(userId);
    } catch (e) {
      emit(WorkspaceError("Failed to update workspace: $e"));
    }
  }
}
