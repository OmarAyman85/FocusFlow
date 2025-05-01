import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/features/workspace/data/models/workspace.dart';

class WorkspaceRemoteDataSource {
  final FirebaseFirestore firestore;

  WorkspaceRemoteDataSource(this.firestore);

  Future<List<WorkspaceModel>> getUserWorkspaces(String userId) async {
    final query =
        await firestore
            .collection('workspaces')
            .where('members', arrayContains: userId)
            .get();

    return query.docs
        .map((doc) => WorkspaceModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> createWorkspace(Map<String, dynamic> workspaceData) async {
    await firestore.collection('workspaces').add(workspaceData);
  }
}
