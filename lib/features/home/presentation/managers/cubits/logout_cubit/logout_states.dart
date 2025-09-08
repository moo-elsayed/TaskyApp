abstract class LogoutStates {}

class LogoutInitial extends LogoutStates {}

class LogoutSuccess extends LogoutStates {}

class LogoutFailure extends LogoutStates {
  final String error;

  LogoutFailure(this.error);
}
