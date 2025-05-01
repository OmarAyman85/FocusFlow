import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final List<Workspace> _workspaces = [];

  @override
  Future<void> createWorkspace(Workspace workspace) async {
    _workspaces.add(workspace);
  }

  @override
  List<Workspace> getWorkspaces() => _workspaces;
}
