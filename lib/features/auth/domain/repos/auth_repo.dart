import 'package:tasky_app/core/helpers/network_response.dart';

abstract class AuthRepository {
  Future<NetworkResponse> signInEmailAndPassword({
    required String email,
    required String password,
  });

  Future<NetworkResponse> signUpEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });

  Future<void> sendEmailVerification();

  Future<NetworkResponse> googleSignIn();

  Future<NetworkResponse> forgetPassword(String email);
}
