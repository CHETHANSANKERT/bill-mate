part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}

final class LoadAllCustomers extends CustomerEvent {}

final class AddCustomer extends CustomerEvent {
  final Customer customer;
  AddCustomer(this.customer);
}

final class DeleteCustomer extends CustomerEvent {
  final String customerId;
  DeleteCustomer(this.customerId);
}
