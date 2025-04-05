
abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoginLoadingState extends AuthStates {}
class AuthLoginSuccessState extends AuthStates {}
class AuthLoginErrorState extends AuthStates {
  final String error;
  AuthLoginErrorState({required this.error});
}

class AuthRegisterLoadingState extends AuthStates {}
class AuthRegisterSuccessState extends AuthStates {}
class AuthRegisterErrorState extends AuthStates {
  final String error;
  AuthRegisterErrorState({required this.error});
}

class AuthLoading extends AuthStates {}
class AuthSuccess extends AuthStates {}
class AuthError extends AuthStates {}

class IsVisibleState extends AuthStates {}
