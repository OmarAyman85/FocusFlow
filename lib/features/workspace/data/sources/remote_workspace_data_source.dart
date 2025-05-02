import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';

abstract class WorkspaceRemoteDataSource {
  Future<void> createWorkspace(Workspace workspace);
  Stream<List<Workspace>> getWorkspaces(String userId);
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final FirebaseFirestore firestore;

  WorkspaceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createWorkspace(Workspace workspace) async {
    await firestore.collection('workspaces').add(workspace.toMap());
  }

  @override
  Stream<List<Workspace>> getWorkspaces(String userId) {
    return firestore.collection('workspaces').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            return Workspace.fromMap(doc.data());
          })
          .where((workspace) {
            final isCreator = workspace.createdById == userId;
            final isMember = workspace.members.any((m) => m.id == userId);
            return isCreator || isMember;
          })
          .toList();
    });
  }
}
