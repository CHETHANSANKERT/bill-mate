// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
// ignore: unused_import
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user =
          {};
      final authToken = 'dummy_auth_token';

      emit(LoginSuccess(user: user, authToken: authToken));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
