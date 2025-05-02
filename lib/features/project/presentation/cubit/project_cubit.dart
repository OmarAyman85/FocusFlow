import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/project/domain/entities/project.dart';
import 'package:focusflow/features/project/domain/usecases/create_page_use_case.dart';
import 'package:focusflow/features/project/domain/usecases/get_projects_use_case.dart';
import 'package:focusflow/injection_container.dart';
import 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit() : super(ProjectInitial());

  void loadProjects(String workspaceId) async {
    emit(ProjectLoading());
    try {
      final projects = await sl<GetProjectsUseCase>().call(workspaceId);
      emit(ProjectLoaded(projects));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  void createProject(Project project) async {
    try {
      await sl<CreateProjectUseCase>().call(project);
      loadProjects(project.workspaceId);
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }
}
