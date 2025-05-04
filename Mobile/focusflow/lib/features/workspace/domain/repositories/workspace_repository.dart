import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';

abstract class WorkspaceRepository {
  Future<void> createWorkspace(Workspace workspace);
  Stream<List<Workspace>> getWorkspaces(String userId);
  Future<void> addMemberToWorkspace(String workspaceId, Member member);
  Future<int> getBoardCount(String workspaceId);
  Future<void> deleteWorkspace(String workspaceId);
  Future<void> updateWorkspace(String workspaceId, Workspace updatedWorkspace);
}
