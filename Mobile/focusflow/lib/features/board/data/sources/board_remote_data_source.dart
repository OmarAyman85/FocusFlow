import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/board/data/model/board_model.dart';
import 'package:focusflow/features/board/domain/entities/board.dart';

abstract class BoardRemoteDataSource {
  Future<void> createBoard(Board board);
  Future<List<Board>> getBoards(String workspaceId);
  Future<void> addBoardMember(
    String workspaceId,
    String boardId,
    Member member,
  );
  Future<int> getTaskCount(String workspaceId, String boardId);
  Future<void> deleteBoard(String workspaceId, String boardId);
  Future<void> updateBoard(Board board);
}

class BoardRemoteDataSourceImpl implements BoardRemoteDataSource {
  final FirebaseFirestore firestore;

  BoardRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createBoard(Board board) async {
    final docRef = firestore
        .collection('workspaces')
        .doc(board.workspaceId)
        .collection('boards')
        .doc(board.id);

    final boardModel = BoardModel(
      id: board.id,
      workspaceId: board.workspaceId,
      name: board.name,
      description: board.description,
      numberOfMembers: board.numberOfMembers,
      numberOfTasks: board.numberOfTasks,
      createdById: board.createdById,
      createdByName: board.createdByName,
      members: board.members,
    );

    await docRef.set(boardModel.toMap());
  }

  @override
  Future<List<Board>> getBoards(String workspaceId) async {
    final snapshot =
        await firestore
            .collection('workspaces')
            .doc(workspaceId)
            .collection('boards')
            .get();

    return snapshot.docs
        .map((doc) => BoardModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addBoardMember(
    String workspaceId,
    String boardId,
    Member member,
  ) async {
    final docRef = firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('boards')
        .doc(boardId);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception("Board not found");

      final data = snapshot.data()!;
      final members = List<Map<String, dynamic>>.from(data['members'] ?? []);

      if (members.any((m) => m['id'] == member.id)) return;

      members.add(member.toMap());

      transaction.update(docRef, {
        'members': members,
        'numberOfMembers': members.length,
      });
    });
  }

  @override
  Future<int> getTaskCount(String workspaceId, String boardId) async {
    try {
      final taskSnapshot =
          await firestore
              .collection('workspaces')
              .doc(workspaceId)
              .collection('boards')
              .doc(boardId)
              .collection('tasks')
              .get();

      return taskSnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> deleteBoard(String workspaceId, String boardId) async {
    final boardRef = firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('boards')
        .doc(boardId);

    final tasksRef = boardRef.collection('tasks');
    final tasksSnapshot = await tasksRef.get();
    for (var doc in tasksSnapshot.docs) {
      await doc.reference.delete();
    }

    await boardRef.delete();
  }

  @override
  Future<void> updateBoard(Board board) async {
    final docRef = firestore
        .collection('workspaces')
        .doc(board.workspaceId)
        .collection('boards')
        .doc(board.id);

    final boardModel = BoardModel(
      id: board.id,
      workspaceId: board.workspaceId,
      name: board.name,
      description: board.description,
      numberOfMembers: board.numberOfMembers,
      numberOfTasks: board.numberOfTasks,
      createdById: board.createdById,
      createdByName: board.createdByName,
      members: board.members,
    );

    await docRef.update(boardModel.toMap());
  }
}
