import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/add_member_to_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/create_workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_users_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_workspace_use_case.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  final CreateWorkspaceUseCase createWorkspaceUseCase;
  final GetWorkspacesUseCase getWorkspacesUseCase;
  final AddMemberToWorkspaceUseCase addMemberToWorkspaceUseCase;
  final GetWorkspaceUsersUseCase getUsersUseCase;

  WorkspaceCubit({
    required this.createWorkspaceUseCase,
    required this.getWorkspacesUseCase,
    required this.addMemberToWorkspaceUseCase,
    required this.getUsersUseCase,
  }) : super(WorkspaceState.initial());

  void loadUserWorkspaces(String userId) {
    getWorkspacesUseCase(userId).listen((workspaces) {
      emit(state.copyWith(workspaces: workspaces));
    });
  }

  Future<void> addWorkspace(Workspace workspace) async {
    await createWorkspaceUseCase(workspace);
  }

  Future<void> addMember(String workspaceId, Member member) async {
    await addMemberToWorkspaceUseCase(workspaceId, member);
  }

  Future<List<Member>> getUsers() async {
    return getUsersUseCase();
  }
}
