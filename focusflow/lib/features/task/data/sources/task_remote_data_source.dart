import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<void> createTask({
    required String workspaceId,
    required String boardId,
    required TaskModel task,
  });

  Future<List<TaskModel>> getTasks({
    required String workspaceId,
    required String boardId,
  });

  Future<void> addMemberToTask({
    required String taskId,
    required String memberId,
  });
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createTask({
    required String workspaceId,
    required String boardId,
    required TaskModel task,
  }) async {
    final taskRef =
        firestore
            .collection('workspaces')
            .doc(workspaceId)
            .collection('boards')
            .doc(boardId)
            .collection('tasks')
            .doc();

    final newTask = task.copyWith(id: taskRef.id, createdAt: DateTime.now());

    await taskRef.set(newTask.toMap());
  }

  @override
  Future<List<TaskModel>> getTasks({
    required String workspaceId,
    required String boardId,
  }) async {
    final snapshot =
        await firestore
            .collection('workspaces')
            .doc(workspaceId)
            .collection('boards')
            .doc(boardId)
            .collection('tasks')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addMemberToTask({
    required String taskId,
    required String memberId,
  }) async {
    final taskRef = firestore.collection('tasks').doc(taskId);

    final taskSnapshot = await taskRef.get();

    if (taskSnapshot.exists) {
      final taskData = taskSnapshot.data()!;
      final assignedTo = List<String>.from(taskData['assignedTo'] ?? []);

      if (!assignedTo.contains(memberId)) {
        assignedTo.add(memberId);
      }

      await taskRef.update({'assignedTo': assignedTo});
    } else {
      throw Exception('Task not found');
    }
  }
}
