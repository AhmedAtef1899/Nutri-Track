
abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeBarState extends AppStates{}

class GetUserLoading extends AppStates{}
class GetUserSuccess extends AppStates{}
class GetUserError extends AppStates{}

class UpdateUserLoading extends AppStates{}
class UpdateUserSuccess extends AppStates{}
class UpdateUserError extends AppStates{
  final String error;
  UpdateUserError({required this.error});
}
