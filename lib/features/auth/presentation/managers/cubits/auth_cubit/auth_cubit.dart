import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/features/auth/data/repos/firebase_auth_repo_imp.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit(this.firebaseAuthRepositoryImplementation) : super(AuthInitial());

  final FirebaseAuthRepositoryImplementation
  firebaseAuthRepositoryImplementation;

  Future<void> signUpEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());
    try {
      await firebaseAuthRepositoryImplementation.signUpEmailAndPassword(
        email: email,
        password: password,
      );
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(errorMessage: e.toString()));
    }
  }

  Future<void> signInEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());
    try {
      await firebaseAuthRepositoryImplementation.signInEmailAndPassword(
        email: email,
        password: password,
      );
      emit(SignInSuccess());
    } catch (e) {
      emit(SignInFailure(errorMessage: e.toString()));
    }
  }

  Future<void> forgetPassword(String email) async {
    emit(ForgetPasswordLoading());
    try {
      await firebaseAuthRepositoryImplementation.forgetPassword(email);
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordFailure(errorMessage: e.toString()));
    }
  }

  Future googleSignIn() async {
    emit(GoogleSignInLoading());
    try {
      await firebaseAuthRepositoryImplementation.googleSignIn();
      emit(GoogleSignInSuccess());
    } catch (e) {
      emit(GoogleSignInFailure(errorMessage: e.toString()));
    }
  }
}
