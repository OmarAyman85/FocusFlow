import 'package:dartz/dartz.dart';
import 'package:focusflow/core/usecases/usecase.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/injection_container.dart';

import '../repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<Either, UserModel> {
  @override
  Future<Either> call({UserModel? params}) async {
    final result = await sl<AuthRepository>().signUp(params!);

    return result.fold(
      (failure) {
        return Left(failure);
      },
      (userModel) {
        return Right(userModel);
      },
    );
  }
}
