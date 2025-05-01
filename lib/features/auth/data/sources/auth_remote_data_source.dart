import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusflow/core/errors/failure.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> signUp(UserModel userModel);
  // Future<UserModel?> signIn(String email, String password);
  Future<void> signOut();
  // Future<UserModel?> getCurrentUser();
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
          password: '', // We don't store the password
        );
        try {
          await firestore.collection('users').doc(user.uid).set(model.toMap());
        } catch (e) {
          return Left(Failure('Failed to save user to Firestore'));
        }
        return Right(model); // Return UserModel to Repository
      }
      return Left(Failure("User Already Exists"));
    } on FirebaseAuthException catch (e) {
      // Check for specific Firebase errors like email already in use
      if (e.code == 'email-already-in-use') {
        return Left(Failure('Email already in use'));
      } else if (e.code == 'invalid-email') {
        return Left(Failure('Invalid email'));
      } else if (e.code == 'weak-password') {
        return Left(Failure('Weak password'));
      }
      return Left(Failure('${e.code} - ${e.message}'));
    } catch (e) {
      return Left(Failure(e.toString())); // Handle other generic exceptions
    }
  }

  // Future<UserModel?> signIn(String email, String password) async {
  //   final credential = await auth.signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   final user = credential.user;
  //   if (user != null) {
  //     final doc = await firestore.collection('users').doc(user.uid).get();
  //     return UserModel.fromMap(doc.data()!);
  //   }
  //   return null;
  // }

  @override
  Future<void> signOut() async {
    auth.signOut();
  }

  // Future<UserModel?> getCurrentUser() async {
  //   final user = auth.currentUser;
  //   if (user == null) return null;
  //   final doc = await firestore.collection('users').doc(user.uid).get();
  //   return UserModel.fromMap(doc.data()!);
  // }
}
