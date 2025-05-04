import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class AddMemberToWorkspaceUseCase {
  Future<void> call(String workspaceId, Member member) async {
    return sl<WorkspaceRepository>().addMemberToWorkspace(workspaceId, member);
  }
}
