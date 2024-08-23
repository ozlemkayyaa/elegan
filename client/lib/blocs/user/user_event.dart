import 'package:elegan/models/user.dart';
import 'package:flutter/material.dart';

abstract class UserEvent {}

class GetUserEvent extends UserEvent {
  final BuildContext context;

  GetUserEvent({required this.context});
}

class GetAllUsersEvent extends UserEvent {}

class UpdateUserEvent extends UserEvent {
  final User user;

  UpdateUserEvent({required this.user});
}

class DeleteUserEvent extends UserEvent {}

class BlockUserEvent extends UserEvent {
  final String userId;

  BlockUserEvent({required this.userId});
}

class UnblockUserEvent extends UserEvent {
  final String userId;

  UnblockUserEvent({required this.userId});
}
