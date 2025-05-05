import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';

abstract class WorkspaceRemoteDataSource {
  Future<void> createWorkspace(Workspace workspace);
  Stream<List<Workspace>> getWorkspaces(String userId);
  Future<void> addMemberToWorkspace(String workspaceId, Member member);
  Future<int> getBoardCount(String workspaceId);
  Future<void> deleteWorkspace(String workspaceId);
  Future<void> updateWorkspace(String workspaceId, Workspace updatedWorkspace);
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
            final data = doc.data();
            return Workspace.fromMap(data, doc.id);
          })
          .where((workspace) {
            final isCreator = workspace.createdById == userId;
            final isMember = workspace.members.any((m) => m.id == userId);
            return isCreator || isMember;
          })
          .toList();
    });
  }

  @override
  Future<void> addMemberToWorkspace(String workspaceId, Member member) async {
    final docRef = firestore.collection('workspaces').doc(workspaceId);
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception("Workspace not found");

      final members = List<Map<String, dynamic>>.from(
        snapshot['members'] ?? [],
      );

      if (members.any((m) => m['id'] == member.id)) return;

      members.add(member.toMap());

      transaction.update(docRef, {
        'members': members,
        'numberOfMembers': members.length,
      });
    });
  }

  @override
  Future<int> getBoardCount(String workspaceId) async {
    try {
      final boardSnapshot =
          await firestore
              .collection('workspaces')
              .doc(workspaceId)
              .collection('boards')
              .get();
      return boardSnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) async {
    final workspaceRef = firestore.collection('workspaces').doc(workspaceId);
    final boardsSnapshot = await workspaceRef.collection('boards').get();
    for (final boardDoc in boardsSnapshot.docs) {
      final tasksSnapshot = await boardDoc.reference.collection('tasks').get();
      for (final taskDoc in tasksSnapshot.docs) {
        await taskDoc.reference.delete();
      }
      await boardDoc.reference.delete();
    }
    await workspaceRef.delete();
  }

  @override
  Future<void> updateWorkspace(
    String workspaceId,
    Workspace updatedWorkspace,
  ) async {
    final workspaceRef = firestore.collection('workspaces').doc(workspaceId);
    await workspaceRef.update(updatedWorkspace.toMap());
  }
}
