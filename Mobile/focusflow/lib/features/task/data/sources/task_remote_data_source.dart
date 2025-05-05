import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:focusflow/core/services/email_service.dart';
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

  // @override
  // Future<void> createTask({
  //   required String workspaceId,
  //   required String boardId,
  //   required TaskModel task,
  // }) async {
  //   final taskRef =
  //       firestore
  //           .collection('workspaces')
  //           .doc(workspaceId)
  //           .collection('boards')
  //           .doc(boardId)
  //           .collection('tasks')
  //           .doc();

  //   final newTask = task.copyWith(id: taskRef.id, createdAt: DateTime.now());

  //   await taskRef.set(newTask.toMap());
  // }
  @override
  Future<void> createTask({
    required String workspaceId,
    required String boardId,
    required TaskModel task,
  }) async {
    // Create a reference to Firestore for the task
    final taskRef =
        firestore
            .collection('workspaces')
            .doc(workspaceId)
            .collection('boards')
            .doc(boardId)
            .collection('tasks')
            .doc();

    // Add the task to Firestore with a new ID and createdAt timestamp
    final newTask = task.copyWith(id: taskRef.id, createdAt: DateTime.now());

    await taskRef.set(newTask.toMap());

    // // Now, send emails to all assigned members
    // final emailService = EmailService();

    // // For each assigned member in the task, send an email
    // for (var memberName in task.assignedTo) {
    //   // Fetch the member's email from Firestore based on their name
    //   final memberEmail = await _getUserEmailByName(memberName);

    //   // Send the email to the member
    //   await emailService.sendEmail(
    //     memberEmail,
    //     'You have been assigned a new task',
    //     'A new task has been created and assigned to you. Please check your dashboard for details.',
    //   );
    // }
  }

  // Future<String> _getUserEmailByName(String memberName) async {
  //   final querySnapshot =
  //       await firestore
  //           .collection('users')
  //           .where('name', isEqualTo: memberName)
  //           .get();

  //   if (querySnapshot.docs.isNotEmpty) {
  //     final userDoc = querySnapshot.docs.first;
  //     final userData = userDoc.data();
  //     return userData['email'] ?? '';
  //   } else {
  //     throw Exception('User not found');
  //   }
  // }

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
      // First compare by dueDate
      int dateComparison = (a.dueDate ?? DateTime(9999)).compareTo(
        b.dueDate ?? DateTime(9999),
      );

      // If dueDate is the same, compare by status
      if (dateComparison == 0) {
        return a.status.compareTo(b.status);
      }

      return dateComparison;
    });

    return tasks;
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
