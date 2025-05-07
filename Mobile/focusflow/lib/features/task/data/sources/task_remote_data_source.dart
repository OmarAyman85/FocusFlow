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

  Future<void> deleteTask({
    required String workspaceId,
    required String boardId,
    required String taskId,
  });

  Future<void> updateTask({
    required String workspaceId,
    required String boardId,
    required TaskModel task,
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
    for (final member in newTask.assignedTo) {
      final userQuery =
          await firestore
              .collection('users')
              .where('name', isEqualTo: member.name)
              .limit(1)
              .get();

      if (userQuery.docs.isEmpty) continue;

      final userDoc = userQuery.docs.first;
      final userEmail = userDoc['email'];
      final taskTitle = newTask.title;

      print('''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📧 Simulated Email Notification
To      : $userEmail
Subject : You have been assigned to a new task: "$taskTitle"

Dear ${member.name},

You have been assigned to the task titled "$taskTitle".

Please log in to your FocusFlow account to view the task and begin work.

Thank you for your commitment to team success.

— FocusFlow Notifications (no-reply@focusflow.com)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
    }
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

    final tasks =
        snapshot.docs
            .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
            .toList();

    tasks.sort((a, b) {
      int dateComparison = (a.dueDate ?? DateTime(9999)).compareTo(
        b.dueDate ?? DateTime(9999),
      );

      if (dateComparison == 0) {
        return a.status.compareTo(b.status);
      }

      return dateComparison;
    });

    return tasks;
  }

  @override
  Future<void> deleteTask({
    required String workspaceId,
    required String boardId,
    required String taskId,
  }) async {
    try {
      await firestore
          .collection('workspaces')
          .doc(workspaceId)
          .collection('boards')
          .doc(boardId)
          .collection('tasks')
          .doc(taskId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<void> updateTask({
    required String workspaceId,
    required String boardId,
    required TaskModel task,
  }) async {
    final taskRef = firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('boards')
        .doc(boardId)
        .collection('tasks')
        .doc(task.id);

    final taskSnapshot = await taskRef.get();

    if (!taskSnapshot.exists) {
      throw Exception('Task not found');
    }

    await taskRef.update(task.toMap());
  }
}
