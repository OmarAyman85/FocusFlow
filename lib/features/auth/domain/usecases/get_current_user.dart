import 'package:dartz/dartz.dart';
import 'package:focusflow/core/errors/failure.dart';
import 'package:focusflow/core/usecases/usecase.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase
    implements UseCase<Either<Failure, UserModel>, void> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call({void params}) async {
    return await repository.getCurrentUser();
  }
}
