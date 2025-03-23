
abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoginLoadingState extends AuthStates {}
class AuthLoginSuccessState extends AuthStates {}
class AuthLoginErrorState extends AuthStates {}

class AuthRegisterLoadingState extends AuthStates {}
class AuthRegisterSuccessState extends AuthStates {}
class AuthRegisterErrorState extends AuthStates {}
