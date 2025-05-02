import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/create_workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_users_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/add_member_to_workspace_use_case.dart';
import 'package:focusflow/injection_container.dart';
import 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit() : super(WorkspaceInitial());

  void loadWorkspaces(String userId) async {
    emit(WorkspaceLoading());
    try {
      final stream = sl<GetWorkspacesUseCase>().call(userId);
      stream.listen(
        (workspaces) {
          emit(WorkspaceLoaded(workspaces));
        },
        onError: (e) {
          emit(WorkspaceError(e.toString()));
        },
      );
    } catch (e) {
      emit(WorkspaceError(e.toString()));
    }
  }

  void createWorkspace(Workspace workspace, String userId) async {
    try {
      await sl<CreateWorkspaceUseCase>().call(workspace);
      loadWorkspaces(userId);
    } catch (e) {
      emit(WorkspaceError(e.toString()));
    }
  }

  Future<List<Member>> getUsers() async {
    return await sl<GetWorkspaceUsersUseCase>().call();
  }

  Future<void> addWorkspaceMember(
    String workspaceId,
    Member member,
    String userId,
  ) async {
    try {
      await sl<AddMemberToWorkspaceUseCase>().call(workspaceId, member);
      loadWorkspaces(userId); // Pass the userId here
    } catch (e) {
      emit(WorkspaceError(e.toString()));
    }
  }
}
