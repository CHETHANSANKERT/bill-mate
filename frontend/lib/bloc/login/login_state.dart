part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final dynamic user;
  final String authToken;

  LoginSuccess({required this.user, required this.authToken});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
