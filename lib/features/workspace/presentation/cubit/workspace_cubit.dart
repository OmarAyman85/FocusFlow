import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/add_member_to_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/create_workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_project_count.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_users_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_workspace_use_case.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';
import 'package:focusflow/injection_container.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit() : super(WorkspaceInitial());

  /// Loads all workspaces for a user and augments them with project count
  void loadWorkspaces(String userId) async {
    emit(WorkspaceLoading());
    try {
      final stream = sl<GetWorkspacesUseCase>().call(userId);

      stream.listen(
        (workspaces) async {
          final List<Workspace> enrichedWorkspaces = [];

          for (final workspace in workspaces) {
            final count = await sl<GetProjectCountUseCase>().call(workspace.id);
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

  /// Creates a new workspace and reloads all workspaces for the user
  void createWorkspace(Workspace workspace, String userId) async {
    try {
      await sl<CreateWorkspaceUseCase>().call(workspace);
      loadWorkspaces(userId);
    } catch (e) {
      emit(WorkspaceError("Workspace creation failed: $e"));
    }
  }

  /// Retrieves users eligible to be added to a workspace
  Future<List<Member>> getUsers() async {
    try {
      return await sl<GetWorkspaceUsersUseCase>().call();
    } catch (e) {
      emit(WorkspaceError("Failed to load users: $e"));
      return [];
    }
  }

  /// Adds a member to a workspace and reloads workspaces for the user
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
}
