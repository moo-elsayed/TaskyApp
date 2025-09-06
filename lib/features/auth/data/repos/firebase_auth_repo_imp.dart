import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasky_app/core/helpers/keys.dart';
import '../../domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class FirebaseAuthRepositoryImplementation implements AuthRepository {
  @override
  Future googleSignIn() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.signOut();

      await signIn.initialize(
        clientId: AppKeys.clientId,
        serverClientId: AppKeys.serverClientId,
      );
      final GoogleSignInAccount? googleUser = await signIn
          .attemptLightweightAuthentication();

      if (googleUser == null) {
        throw "User canceled sign in";
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw "No idToken received from Google";
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      await _saveUserData(
        name: googleUser.displayName!,
        email: googleUser.email,
        isVerified: true,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future signInEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!credential.user!.emailVerified) {
        await sendEmailVerification();
        throw 'please verify your email';
      } else {
        await _saveUserData(
          email: credential.user!.email!,
          password: password,
          isVerified: true,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw ('Wrong password provided for that user.');
      } else {
        throw e.code;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> signUpEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification();
      await _saveUserData(
        name: username,
        email: email,
        password: password,
        isVerified: false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that email.');
      } else {
        throw e.code;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> forgetPassword(String email) async =>
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

  @override
  Future<void> sendEmailVerification() async =>
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

  Future<void> _saveUserData({
    String? name,
    required String email,
    String? password,
    required bool isVerified,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final db = FirebaseFirestore.instance;
    final user = UserModel(
      name: name,
      email: email,
      password: password,
      isVerified: isVerified,
    );
    final userDocumentRef = db.collection('users').doc(userId);
    await userDocumentRef.set(user.toJson(), SetOptions(merge: true));
  }
}
