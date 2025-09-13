import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasky_app/core/helpers/keys.dart';
import 'package:tasky_app/core/helpers/network_reponse.dart';
import '../../domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class FirebaseAuthRepositoryImplementation implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<NetworkResponse> googleSignIn() async {
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
        return NetworkFailure(Exception('User canceled sign in'));
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        return NetworkFailure(Exception('No idToken received from Google'));
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      await _saveUserData(
        UserModel(
          email: googleUser.email,
          isVerified: true,
          name: googleUser.displayName,
          id: _auth.currentUser!.uid,
        ),
      );
      return NetworkSuccess();
    } on FirebaseAuthException catch (e) {
      return NetworkFailure(Exception(e.message));
    } on PlatformException catch (e) {
      return NetworkFailure(Exception(e.message));
    } catch (e) {
      return NetworkFailure(Exception(e.toString()));
    }
  }

  @override
  Future<NetworkResponse> signInEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!credential.user!.emailVerified) {
        await sendEmailVerification();
        return NetworkFailure(Exception('please verify your email'));
      } else {
        await _saveUserData(
          UserModel(
            email: credential.user!.email!,
            password: password,
            isVerified: true,
            id: credential.user!.uid,
          ),
        );
        return NetworkSuccess();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return NetworkFailure(Exception('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        return NetworkFailure(
          Exception('Wrong password provided for that user.'),
        );
      } else {
        return NetworkFailure(Exception(e.code));
      }
    } catch (e) {
      return NetworkFailure(Exception(e.toString()));
    }
  }

  @override
  Future<NetworkResponse> signUpEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification();

      await _saveUserData(
        UserModel(
          name: username,
          email: email,
          isVerified: false,
          password: password,
          id: credential.user!.uid,
        ),
      );
      return NetworkSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return NetworkFailure(Exception('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return NetworkFailure(
          Exception('The account already exists for that email.'),
        );
      } else {
        return NetworkFailure(Exception(e.code));
      }
    } catch (e) {
      return NetworkFailure(Exception(e.toString()));
    }
  }

  @override
  Future<NetworkResponse> forgetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return NetworkSuccess();
    } on FirebaseAuthException catch (e) {
      return NetworkFailure(Exception(e.code));
    } catch (e) {
      return NetworkFailure(Exception(e.toString()));
    }
  }

  @override
  Future<void> sendEmailVerification() async =>
      await _auth.currentUser?.sendEmailVerification();

  Future<void> _saveUserData(UserModel userModel) async {
    final userId = _auth.currentUser?.uid;
    final db = FirebaseFirestore.instance;
    final userDocumentRef = db.collection('users').doc(userId);
    await userDocumentRef.set(userModel.toJson(), SetOptions(merge: true));
  }
}
