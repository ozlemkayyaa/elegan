abstract class AuthState {}

class AuthInitial extends AuthState {}

class LogOutState extends AuthState {}

class SuccessAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class FailureAuthState extends AuthState {
  final String error;

  FailureAuthState({required this.error});
}
