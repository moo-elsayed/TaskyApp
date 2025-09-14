import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/features/auth/data/repos/firebase_auth_repo_imp.dart';
import '../../../../../../core/helpers/network_response.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit(this.firebaseAuthRepositoryImplementation) : super(AuthInitial());

  final FirebaseAuthRepositoryImplementation
  firebaseAuthRepositoryImplementation;

  Future<void> signUpEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(SignUpLoading());
    var result = await firebaseAuthRepositoryImplementation
        .signUpEmailAndPassword(
          email: email,
          password: password,
          username: username,
        );
    switch (result) {
      case NetworkSuccess():
        emit(SignUpSuccess());
      case NetworkFailure():
        emit(SignUpFailure(errorMessage: result.exception.toString()));
    }
  }

  Future<void> signInEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());
    var result = await firebaseAuthRepositoryImplementation
        .signInEmailAndPassword(email: email, password: password);
    switch (result) {
      case NetworkSuccess():
        emit(SignInSuccess());
      case NetworkFailure():
        emit(SignInFailure(errorMessage: result.exception.toString()));
    }
  }

  Future<void> forgetPassword(String email) async {
    emit(ForgetPasswordLoading());
    var result = await firebaseAuthRepositoryImplementation.forgetPassword(
      email,
    );
    switch (result) {
      case NetworkSuccess():
        emit(ForgetPasswordSuccess());
      case NetworkFailure():
        emit(ForgetPasswordFailure(errorMessage: result.exception.toString()));
    }
  }

  Future googleSignIn() async {
    emit(GoogleSignInLoading());
    var result = await firebaseAuthRepositoryImplementation.googleSignIn();
    switch (result) {
      case NetworkSuccess():
        emit(GoogleSignInSuccess());
      case NetworkFailure():
        emit(GoogleSignInFailure(errorMessage: result.exception.toString()));
    }
  }
}
