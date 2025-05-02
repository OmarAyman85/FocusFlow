import 'package:focusflow/features/project/domain/entities/project.dart';

abstract class ProjectRepository {
  Future<void> createProject(Project project);
  Future<List<Project>> getProjects(String workspaceId);
}
