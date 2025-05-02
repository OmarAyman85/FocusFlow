// get_all_users_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:focusflow/core/errors/failure.dart';
import 'package:focusflow/core/usecases/usecase.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';

class GetAllUsersUseCase
    implements UseCase<Either<Failure, List<UserModel>>, void> {
  final AuthRepository repository;

  GetAllUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserModel>>> call({void params}) async {
    return await repository.getAllUsers();
  }
}
