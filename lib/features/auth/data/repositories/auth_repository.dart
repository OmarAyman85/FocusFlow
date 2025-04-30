import 'package:dartz/dartz.dart';
import 'package:focusflow/core/errors/failure.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:focusflow/features/auth/domain/entities/user_entity.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:focusflow/injection_container.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, AppUser>> signUp(UserModel userModel) async {
    try {
      final userModelResult = await sl<AuthRemoteDataSource>().signUp(
        userModel,
      );
      return userModelResult.fold(
        (failure) {
          return Left(
            failure,
          ); // Return failure if data source returns an error
        },
        (userModel) {
          // Map the data source UserModel to AppUser (Entity)
          final appUser = AppUser(
            uid: userModel.uid, // Mapping to AppUser
            email: userModel.email,
            name: userModel.name,
            password: userModel.password,
          );
          return Right(appUser); // Return the mapped AppUser (Entity)
        },
      );
    } catch (e) {
      return Left(Failure(e.toString())); // Handle any other errors
    }
  }

  // @override
  // Future<AppUser?> signIn(String email, String password) async {
  //   final credential = await _firebaseAuth.signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   final user = credential.user;
  //   if (user != null) {
  //     final userDoc = await _firestore.collection('users').doc(user.uid).get();
  //     final data = userDoc.data()!;
  //     return AppUser(uid: user.uid, email: data['email'], name: data['name']);
  //   }
  //   return null;
  // }

  // @override
  // Future<void> signOut() async => await _firebaseAuth.signOut();

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
