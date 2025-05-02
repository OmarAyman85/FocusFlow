import 'package:focusflow/features/workspace/data/sources/remote_workspace_data_source.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/injection_container.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remoteDataSource;

  WorkspaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createWorkspace(Workspace workspace) async {
    try {
      return sl<WorkspaceRemoteDataSource>().createWorkspace(workspace);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Workspace>> getWorkspaces() {
    try {
      return sl<WorkspaceRemoteDataSource>().getWorkspaces();
    } catch (e) {
      return Stream.error(e.toString());
    }
  }
}
