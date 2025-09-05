abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class SignInLoading extends AuthStates {}

class SignInSuccess extends AuthStates {}

class VerifyEmail extends AuthStates {}

class SignInFailure extends AuthStates {
  final String errorMessage;

  SignInFailure({required this.errorMessage});
}

class SignUpLoading extends AuthStates {}

class SignUpSuccess extends AuthStates {}

class SignUpFailure extends AuthStates {
  final String errorMessage;

  SignUpFailure({required this.errorMessage});
}

class ForgetPasswordLoading extends AuthStates {}

class ForgetPasswordSuccess extends AuthStates {}

class ForgetPasswordFailure extends AuthStates {
  final String errorMessage;

  ForgetPasswordFailure({required this.errorMessage});
}

class GoogleSignInLoading extends AuthStates {}

class GoogleSignInSuccess extends AuthStates {}

class GoogleSignInFailure extends AuthStates {
  final String errorMessage;

  GoogleSignInFailure({required this.errorMessage});
}