import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';

abstract class WorkspaceRepository {
  Future<void> createWorkspace(Workspace workspace);
  Stream<List<Workspace>> getWorkspaces(String userId);
  Future<void> addMemberToWorkspace(String workspaceId, Member member);
  Future<List<Member>> getUsers();
  Future<int> getBoardCount(String workspaceId);
}
