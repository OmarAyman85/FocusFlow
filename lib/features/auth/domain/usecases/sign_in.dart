import 'package:dartz/dartz.dart';
import 'package:focusflow/core/usecases/usecase.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase implements UseCase<Either, UserModel> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either> call({UserModel? params}) async {
    return await repository.signIn(params!);
  }
}
