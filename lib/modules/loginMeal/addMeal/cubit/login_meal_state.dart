
abstract class LoginMealState {}

class LoginMealInitial extends LoginMealState {}

class GetMealLoading extends LoginMealState {}
class GetMealSuccess extends LoginMealState {}
class GetMealError extends LoginMealState {}

class AddMealLoading extends LoginMealState {}
class AddMealSuccess extends LoginMealState {}
class AddMealError extends LoginMealState {}
