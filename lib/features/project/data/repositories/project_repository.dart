import 'package:focusflow/features/project/data/sources/project_remote_data_source.dart';
import 'package:focusflow/features/project/domain/entities/project.dart';
import 'package:focusflow/features/project/domain/repositories/project_repository.dart';
import 'package:focusflow/injection_container.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  @override
  Future<void> createProject(Project project) async {
    try {
      return await sl<ProjectRemoteDataSource>().createProject(project);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Project>> getProjects(String workspaceId) async {
    try {
      return await sl<ProjectRemoteDataSource>().getProjects(workspaceId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
