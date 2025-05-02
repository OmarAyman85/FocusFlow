import 'package:focusflow/features/project/domain/entities/project.dart';
import 'package:focusflow/features/project/domain/repositories/project_repository.dart';
import 'package:focusflow/injection_container.dart';

class GetProjectsUseCase {
  Future<List<Project>> call(String workspaceId) {
    return sl<ProjectRepository>().getProjects(workspaceId);
  }
}
