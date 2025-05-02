import 'package:focusflow/features/project/domain/entities/project.dart';
import 'package:focusflow/features/project/domain/repositories/project_repository.dart';
import 'package:focusflow/injection_container.dart';

class CreateProjectUseCase {

  Future<void> call(Project project) {
    return sl<ProjectRepository>().createProject(project);
  }
}
