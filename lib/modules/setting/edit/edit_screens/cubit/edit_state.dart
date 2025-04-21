
class EditState {}

class EditInitial extends EditState {}

class GetLoading extends EditState {}
class GetSuccess extends EditState {}
class GetError extends EditState {}

class UpdateLoading extends EditState {}
class UpdateSuccess extends EditState {}
class UpdateError extends EditState {
  final String error;

  UpdateError({required this.error});
}

class ChangeLangState extends EditState {}
