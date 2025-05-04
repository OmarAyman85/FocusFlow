import 'package:dartz/dartz.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  Future<Either> call({UserModel? params}) async {
    return await sl<AuthRepository>().signIn(params!);
  }
}
