import 'package:elegan/models/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoadingState extends UserState {}

class UserSuccessState extends UserState {
  final User user;

  UserSuccessState({required this.user});
}

class UserErrorState extends UserState {
  final String error;

  UserErrorState({required this.error});
}

class UserUpdated extends UserState {}

class UserDeleted extends UserState {}

class UserBlocked extends UserState {
  final String userId;

  UserBlocked({required this.userId});
}

class UserUnblocked extends UserState {
  final String userId;

  UserUnblocked({required this.userId});
}
