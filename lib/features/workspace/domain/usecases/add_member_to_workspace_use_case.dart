import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';

class AddMemberToWorkspaceUseCase {
  final WorkspaceRepository repository;
  AddMemberToWorkspaceUseCase({required this.repository});
  Future<void> call(String workspaceId, Member member) async {
    return repository.addMemberToWorkspace(workspaceId, member);
  }
}
