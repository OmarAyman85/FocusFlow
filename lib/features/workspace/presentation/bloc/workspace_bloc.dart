import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/workspace.dart';
import '../../domain/usecases/create_workspace.dart';
import '../../domain/usecases/get_user_workspaces.dart';
import 'workspace_event.dart';
import 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final GetUserWorkspaces getUserWorkspaces;
  final CreateWorkspace createWorkspace;

  WorkspaceBloc(this.getUserWorkspaces, this.createWorkspace)
    : super(WorkspaceInitial()) {
    on<LoadWorkspaces>((event, emit) async {
      emit(WorkspaceLoading());
      try {
        final workspaces = await getUserWorkspaces(event.userId);
        emit(WorkspaceLoaded(workspaces));
      } catch (e) {
        emit(WorkspaceError('Failed to load workspaces'));
      }
    });

    on<SubmitWorkspaceForm>((event, emit) async {
      emit(WorkspaceLoading());
      try {
        final workspace = Workspace(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: event.name,
          createdBy: event.userId,
          members: [event.userId],
        );

        await createWorkspace(workspace);
        emit(CreateWorkspaceSuccess());
      } catch (e) {
        emit(WorkspaceError('Failed to create workspace'));
      }
    });
  }
}
