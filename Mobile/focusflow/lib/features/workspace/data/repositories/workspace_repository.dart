import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/workspace/data/sources/remote_workspace_data_source.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  @override
  Future<void> createWorkspace(Workspace workspace) async {
    try {
      return sl<WorkspaceRemoteDataSource>().createWorkspace(workspace);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Workspace>> getWorkspaces(String userId) {
    try {
      return sl<WorkspaceRemoteDataSource>().getWorkspaces(userId);
    } catch (e) {
      return Stream.error(e.toString());
    }
  }

  @override
  Future<void> addMemberToWorkspace(String workspaceId, Member member) async {
    try {
      return sl<WorkspaceRemoteDataSource>().addMemberToWorkspace(
        workspaceId,
        member,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<int> getBoardCount(String workspaceId) {
    return sl<WorkspaceRemoteDataSource>().getBoardCount(workspaceId);
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) {
    return sl<WorkspaceRemoteDataSource>().deleteWorkspace(workspaceId);
  }

  @override
  Future<void> updateWorkspace(String workspaceId, Workspace updatedWorkspace) {
    return sl<WorkspaceRemoteDataSource>().updateWorkspace(
      workspaceId,
      updatedWorkspace,
    );
  }
}
