import 'package:dartz/dartz.dart';
import 'package:focusflow/core/errors/failure.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, UserModel>> signUp(UserModel userModel) async {
    try {
      return sl<AuthRemoteDataSource>().signUp(userModel);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signIn(UserModel userModel) async {
    try {
      return sl<AuthRemoteDataSource>().signIn(userModel);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    return sl<AuthRemoteDataSource>().signOut();
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      return sl<AuthRemoteDataSource>().getCurrentUser();
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      return sl<AuthRemoteDataSource>().getAllUsers();
    } catch (e) {
      return Left(Failure('Failed to fetch users: $e'));
    }
  }
}
