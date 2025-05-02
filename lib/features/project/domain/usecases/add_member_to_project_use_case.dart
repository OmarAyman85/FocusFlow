import 'package:focusflow/features/project/domain/repositories/project_repository.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/injection_container.dart';

class AddMemberToProjectUseCase {
  Future<void> call(String workspaceId, String projectId, Member member) async {
    return sl<ProjectRepository>().addProjectMember(
      workspaceId,
      projectId,
      member,
    );
  }
}
