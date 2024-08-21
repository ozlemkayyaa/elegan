import 'package:elegan/blocs/user/user_event.dart';
import 'package:elegan/blocs/user/user_state.dart';
import 'package:elegan/services/user_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService;
  UserBloc(this._userService) : super(UserInitial()) {
    on<GetUserEvent>(_getUserData);
    on<UpdateUserEvent>(_updateUser);
    on<DeleteUserEvent>(_deleteUser);
  }

  Future<void> _getUserData(GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final userRes = await _userService.getUserData(event.context);
      emit(UserSuccessState(user: userRes));
    } catch (e) {
      emit(UserErrorState(error: e.toString()));
    }
  }

  void _updateUser(UpdateUserEvent event, Emitter<UserState> emit) {
    emit(UserLoadingState());
    try {} catch (e) {
      emit(UserErrorState(error: e.toString()));
    }
  }

  void _deleteUser(DeleteUserEvent event, Emitter<UserState> emit) {
    emit(UserLoadingState());
    try {} catch (e) {
      emit(UserErrorState(error: e.toString()));
    }
  }
}
