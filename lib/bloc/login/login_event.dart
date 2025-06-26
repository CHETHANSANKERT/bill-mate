part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});
}
