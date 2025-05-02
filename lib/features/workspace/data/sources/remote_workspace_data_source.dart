import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';

abstract class WorkspaceRemoteDataSource {
  Future<void> createWorkspace(Workspace workspace);
  Stream<List<Workspace>> getWorkspaces();
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final FirebaseFirestore firestore;

  WorkspaceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createWorkspace(Workspace workspace) async {
    await firestore.collection('workspaces').add(workspace.toMap());
  }

  @override
  Stream<List<Workspace>> getWorkspaces() {
    return firestore.collection('workspaces').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Workspace.fromMap(doc.data());
      }).toList();
    });
  }
}
