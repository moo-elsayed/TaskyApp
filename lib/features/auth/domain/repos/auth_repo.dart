abstract class AuthRepository {
  Future<void> signInEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUpEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });

  Future<void> sendEmailVerification();

  Future<void> googleSignIn();

  Future<void> forgetPassword(String email);
}
