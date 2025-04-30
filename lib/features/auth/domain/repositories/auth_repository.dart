import 'package:dartz/dartz.dart';
import 'package:focusflow/core/errors/failure.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signUp(UserModel userModel);
  // Future<AppUser?> signIn(String email, String password);
  // Future<Either> signUp(String name, String email, String password);
  // Future<void> signOut();
  // Future<AppUser?> getCurrentUser();
}
