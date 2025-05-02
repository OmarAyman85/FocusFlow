import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/features/project/data/model/project_model.dart';
import 'package:focusflow/features/project/domain/entities/project.dart';
import 'package:focusflow/features/workspace/domain/entities/member.dart';

abstract class ProjectRemoteDataSource {
  Future<void> createProject(Project project);
  Future<List<Project>> getProjects(String workspaceId);
  Future<List<Member>> getUsers();
  Future<void> addProjectMember(
    String workspaceId,
    String projectId,
    Member member,
  );
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final FirebaseFirestore firestore;

  ProjectRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createProject(Project project) async {
    final docRef = firestore
        .collection('workspaces')
        .doc(project.workspaceId)
        .collection('projects')
        .doc(project.id);

    final projectModel = ProjectModel(
      id: project.id,
      workspaceId: project.workspaceId,
      name: project.name,
      description: project.description,
      numberOfMembers: project.numberOfMembers,
      numberOfBoards: project.numberOfBoards,
      createdById: project.createdById,
      createdByName: project.createdByName,
      members: project.members,
    );

    await docRef.set(projectModel.toMap());
  }

  @override
  Future<List<Project>> getProjects(String workspaceId) async {
    final snapshot =
        await firestore
            .collection('workspaces')
            .doc(workspaceId)
            .collection('projects')
            .get();

    return snapshot.docs
        .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addProjectMember(
    String workspaceId,
    String projectId,
    Member member,
  ) async {
    final docRef = firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('projects')
        .doc(projectId);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception("Project not found");

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
  Future<List<Member>> getUsers() async {
    final snapshot = await firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Member(id: doc.id, name: data['name']);
    }).toList();
  }
}
