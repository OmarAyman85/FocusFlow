import 'package:dartz/dartz.dart';
import 'package:focusflow/core/errors/failure.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signUp(UserModel userModel);
  Future<void> signOut();
  // Future<AppUser?> signIn(String email, String password);
  // Future<AppUser?> getCurrentUser();
}
