
abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsAddedSuccessState extends UserDetailsState {}
class UserDetailsAddedLoadingState extends UserDetailsState {}
class UserDetailsAddedErrorState extends UserDetailsState {}

class UserDetailsGetSuccessState extends UserDetailsState {}
class UserDetailsGetLoadingState extends UserDetailsState {}
class UserDetailsGetErrorState extends UserDetailsState {}
