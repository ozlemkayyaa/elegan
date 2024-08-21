import 'package:elegan/models/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserSuccessState extends UserState {
  final User user;

  UserSuccessState({required this.user});
}

class UserLoadingState extends UserState {}

class UserErrorState extends UserState {
  final String error;

  UserErrorState({required this.error});
}

class UserUpdated extends UserState {}

class UserDeleted extends UserState {}
