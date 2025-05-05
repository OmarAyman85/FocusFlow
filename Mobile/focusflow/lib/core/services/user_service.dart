import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/core/entities/member.dart';

abstract class UserService {
  Future<List<Member>> getUsers();
  Future<List<Member>> getWorkspaceMembers(String workspaceId);
  Future<List<Member>> getBoardMembers(String workspaceId, String boardId);
}

class UserServiceImpl implements UserService {
  final FirebaseFirestore firestore;

  UserServiceImpl({required this.firestore});

  @override
  Future<List<Member>> getUsers() async {
    final snapshot = await firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Member(id: doc.id, name: data['name']);
    }).toList();
  }

  @override
  Future<List<Member>> getWorkspaceMembers(String workspaceId) async {
    final workspaceDoc =
        await firestore.collection('workspaces').doc(workspaceId).get();
    final data = workspaceDoc.data();
    if (data != null && data['members'] != null) {
      final List<dynamic> membersData = data['members'];
      return membersData.map((member) {
        return Member(id: member['id'], name: member['name']);
      }).toList();
    }
    return [];
  }

  @override
  Future<List<Member>> getBoardMembers(
    String workspaceId,
    String boardId,
  ) async {
    final boardDoc =
        await firestore
            .collection('workspaces')
            .doc(workspaceId)
            .collection('boards')
            .doc(boardId)
            .get();

    final data = boardDoc.data();
    if (data != null && data['members'] != null) {
      final List<dynamic> membersData = data['members'];
      return membersData.map((member) {
        return Member(id: member['id'], name: member['name']);
      }).toList();
    }
    return [];
  }
}
