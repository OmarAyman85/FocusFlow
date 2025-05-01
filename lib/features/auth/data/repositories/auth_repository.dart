import 'package:dartz/dartz.dart';
import 'package:focusflow/core/errors/failure.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:focusflow/injection_container.dart';

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
  Future<void> signOut() {
    return sl<AuthRemoteDataSource>().signOut();
  }

  // @override
  // Future<AppUser?> getCurrentUser() async {
  //   final user = _firebaseAuth.currentUser;
  //   if (user != null) {
  //     final doc = await _firestore.collection('users').doc(user.uid).get();
  //     final data = doc.data();
  //     if (data != null) {
  //       return AppUser(uid: user.uid, email: data['email'], name: data['name']);
  //     }
  //   }
  //   return null;
  // }
}
