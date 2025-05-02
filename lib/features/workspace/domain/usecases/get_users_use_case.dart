import 'package:focusflow/features/workspace/domain/entities/member.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';

class GetUsersUseCase {
  final WorkspaceRepository repository;
  GetUsersUseCase({required this.repository});

  Future<List<Member>> call() async {
    return repository.getUsers();
  }
}
