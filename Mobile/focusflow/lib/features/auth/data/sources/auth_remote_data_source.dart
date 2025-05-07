import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusflow/core/errors/failure.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> signUp(UserModel userModel);
  Future<Either<Failure, UserModel>> signIn(UserModel userModel);
  Future<void> signOut();
  Future<Either<Failure, UserModel>> getCurrentUser();
  Future<Either<Failure, List<UserModel>>> getAllUsers();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({required this.auth, required this.firestore});

  @override
  Future<Either<Failure, UserModel>> signUp(UserModel userModel) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      final user = credential.user;
      if (user != null) {
        final model = UserModel(
          uid: user.uid,
          email: userModel.email,
          name: userModel.name,
          password: '',
          photoUrl: '',
        );
        try {
          await firestore.collection('users').doc(user.uid).set(model.toMap());
        } catch (e) {
          return Left(Failure('Failed to save user to Firestore'));
        }
        return Right(model);
      }
      return Left(Failure("User Already Exists"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Left(Failure('Email already in use'));
      } else if (e.code == 'invalid-email') {
        return Left(Failure('Invalid email'));
      } else if (e.code == 'weak-password') {
        return Left(Failure('Weak password'));
      }
      return Left(Failure('${e.code} - ${e.message}'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signIn(UserModel userModel) async {
    try {
      return auth
          .signInWithEmailAndPassword(
            email: userModel.email,
            password: userModel.password,
          )
          .then((credential) async {
            final user = credential.user;
            if (user != null) {
              final doc =
                  await firestore.collection('users').doc(user.uid).get();
              return Right(UserModel.fromMap(doc.data()!));
            }
            return Left(Failure("User Not Found"));
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(Failure('User not found'));
      } else if (e.code == 'wrong-password') {
        return Left(Failure('Wrong password'));
      }
      return Left(Failure('${e.code} - ${e.message}'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Left(Failure('No user is currently signed in'));
      }
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        return Left(Failure('User not found in Firestore'));
      }
      final userModel = UserModel.fromMap(doc.data()!);
      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(Failure('Failed to get current user: ${e.message}'));
    } on FirebaseException catch (e) {
      return Left(Failure('Failed to get current user: ${e.message}'));
    } catch (e) {
      return Left(Failure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      final querySnapshot = await firestore.collection('users').get();
      final users =
          querySnapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList();
      return Right(users);
    } catch (e) {
      return Left(Failure('Failed to fetch users: $e'));
    }
  }
}
