import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/features/project/data/model/project_model.dart';
import 'package:focusflow/features/project/domain/entities/project.dart';

abstract class ProjectRemoteDataSource {
  Future<void> createProject(Project project);
  Future<List<Project>> getProjects(String workspaceId);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final FirebaseFirestore firestore;

  ProjectRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createProject(Project project) async {
    final projectModel = ProjectModel(
      id: project.id,
      workspaceId: project.workspaceId,
      name: project.name,
      description: project.description,
      memberIds: project.memberIds,
      createdBy: project.createdBy,
      createdByName: project.createdByName,
    );
    await firestore.collection('projects').add(projectModel.toMap());
  }

  @override
  Future<List<Project>> getProjects(String workspaceId) async {
    final snapshot =
        await firestore
            .collection('projects')
            .where('workspaceId', isEqualTo: workspaceId)
            .get();

    return snapshot.docs
        .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
