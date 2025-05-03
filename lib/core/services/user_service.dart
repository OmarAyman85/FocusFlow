import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focusflow/core/entities/member.dart';

abstract class UserService {
  Future<List<Member>> getUsers();
}

class UserServiceImpl implements UserService {
  final FirebaseFirestore firestore;

  UserServiceImpl({required this.firestore});

  @override
  Future<List<Member>> getUsers() async {
    final snapshot = await firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Member(id: doc.id, name: data['name']);
    }).toList();
  }
}
