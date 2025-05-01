import '../../domain/entities/workspace.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../sources/workspace_remote_data_source.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remoteDataSource;

  WorkspaceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Workspace>> getUserWorkspaces(String userId) {
    return remoteDataSource.getUserWorkspaces(userId);
  }

  @override
  Future<void> createWorkspace(Workspace workspace) async {
    // Convert Workspace entity to a model or map if needed
    await remoteDataSource.createWorkspace(workspace.toMap());
  }
}
