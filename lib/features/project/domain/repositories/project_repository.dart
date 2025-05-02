import 'package:focusflow/features/project/domain/entities/project.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';

abstract class ProjectRepository {
  Future<void> createProject(Project project);
  Future<List<Project>> getProjects(String workspaceId);
  Future<List<Member>> getUsers();
  Future<void> addProjectMember(
    String workspaceId,
    String projectId,
    Member member,
  );
}
