import 'dart:async';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasky_app/core/helpers/keys.dart';
import '../../domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification();
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
}
