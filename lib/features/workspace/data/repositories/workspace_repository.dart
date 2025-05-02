import 'package:focusflow/features/workspace/data/sources/remote_workspace_data_source.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';

// workspace_repository_impl.dart
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remoteDataSource;

  WorkspaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createWorkspace(Workspace workspace) async {
    try {
      return remoteDataSource.createWorkspace(workspace);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Workspace>> getWorkspaces(String userId) {
    try {
      return remoteDataSource.getWorkspaces(userId);
    } catch (e) {
      return Stream.error(e.toString());
    }
  }
}


