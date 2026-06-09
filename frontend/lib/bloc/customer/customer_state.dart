part of 'customer_bloc.dart';

@immutable
sealed class CustomerState {}

final class CustomerInitial extends CustomerState {}

final class CustomerLoaded extends CustomerState {
  final List<Map<String, dynamic>> customers;
  CustomerLoaded({required this.customers});
}

final class CustomerAdded extends CustomerState {}

final class CustomerDeleted extends CustomerState {}
