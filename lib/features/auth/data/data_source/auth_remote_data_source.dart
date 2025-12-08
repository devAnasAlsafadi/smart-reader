import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _fireStore;

  AuthRemoteDataSourceImpl({FirebaseAuth? auth, FirebaseFirestore? fireStore})
    : _auth = auth ?? FirebaseAuth.instance,
      _fireStore = fireStore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCred.user!.uid;
      final token = await userCred.user!.getIdToken();
      final doc = await _fireStore.collection("users").doc(uid).get();
      return UserModel.fromFireStore(uid, doc.data()!, token!);
    } catch (e) {
      log('FirebaseUserRepo Error: $e');
      rethrow;
    }
  }
}
