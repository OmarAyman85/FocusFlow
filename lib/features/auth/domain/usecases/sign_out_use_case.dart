import 'package:focusflow/core/usecases/usecase.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase implements UseCase<void, void> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<void> call({void params}) async {
    return await repository.signOut();
  }
}
