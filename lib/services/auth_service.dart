import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // instance of auth 
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // sign user in 
  Future<UserCredential?> signInWithEmailandPassword(
      String email, String password) async {
    try {
      // sign in 
      UserCredential userCredential = 
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );

      // Check if the user object is not null before accessing it
      if (userCredential.user != null) {
        // add a new document for the user in users collection if it doesn't already exist
        await _fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email, 
        }, SetOptions(merge: true));

        return userCredential;
      } else {
        // Handle null user case
        throw Exception('Пользователь равен null после входа');
      }
    } 
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('Ошибка авторизации: $e');
    }
  }

  // create a new user
  Future<UserCredential?> signUpWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = 
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );

      // Check if the user object is not null before accessing it
      if (userCredential.user != null) {
        // after creating the user, create a new document for the user in the users collection
        await _fireStore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email, 
        });

        return userCredential;
      } else {
        // Handle null user case
        throw Exception('Пользователь равен null после регистрации');
      }
    } 
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('Произошла неизвестная ошибка: $e');
    }
  }

  // sign user out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Ошибка при выходе: $e');
    }
  }
}
