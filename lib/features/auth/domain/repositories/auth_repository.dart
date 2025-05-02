import 'package:dartz/dartz.dart';
import 'package:focusflow/core/errors/failure.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signUp(UserModel userModel);
  Future<Either<Failure, UserModel>> signIn(UserModel userModel);
  Future<void> signOut();
  Future<Either<Failure, UserModel>> getCurrentUser();
  Future<Either<Failure, List<UserModel>>> getAllUsers();
}
