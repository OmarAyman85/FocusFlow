import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';

abstract class WorkspaceRemoteDataSource {
  Future<void> createWorkspace(Workspace workspace);
  Stream<List<Workspace>> getWorkspaces(String userId);
  Future<void> addMemberToWorkspace(String workspaceId, Member member);
  Future<List<Member>> getUsers();
  Future<int> getProjectCount(String workspaceId);
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
  Future<List<Member>> getUsers() async {
    final snapshot = await firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Member(id: doc.id, name: data['name']);
    }).toList();
  }

  @override
  Future<int> getProjectCount(String workspaceId) async {
    try {
      final projectSnapshot =
          await firestore
              .collection('workspaces')
              .doc(workspaceId)
              .collection('projects')
              .get();
      return projectSnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }
}
