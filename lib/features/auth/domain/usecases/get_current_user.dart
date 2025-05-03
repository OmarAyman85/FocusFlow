import 'package:dartz/dartz.dart';
import 'package:focusflow/core/errors/failure.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class GetCurrentUserUseCase {
  Future<Either<Failure, UserModel>> call({void params}) async {
    return await sl<AuthRepository>().getCurrentUser();
  }
}
