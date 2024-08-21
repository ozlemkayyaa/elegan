import 'package:elegan/models/user.dart';
import 'package:flutter/material.dart';

abstract class UserEvent {}

class GetUserEvent extends UserEvent {
  final BuildContext context;

  GetUserEvent({required this.context});
}

class UpdateUserEvent extends UserEvent {
  final User user;

  UpdateUserEvent({required this.user});
}

class DeleteUserEvent extends UserEvent {}
