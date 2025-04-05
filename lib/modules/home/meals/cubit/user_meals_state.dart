
abstract class UserMealsState {}

class UserMealsInitial extends UserMealsState {}

class GetUserMealsLoading extends UserMealsState {}
class GetUserMealsSuccess extends UserMealsState {}
class GetUserMealsError extends UserMealsState {}

class RemoveUserMealsLoading extends UserMealsState {}
class RemoveUserMealsSuccess extends UserMealsState {}
class RemoveUserMealsError extends UserMealsState {}

class CompletedUserMealsLoading extends UserMealsState {}
class CompletedUserMealsSuccess extends UserMealsState {}
class CompletedUserMealsError extends UserMealsState {}
