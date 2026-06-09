import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/customer/customer.dart';
import '../../services/local/db_service.dart';

part 'customer_event.dart';
part 'customer_state.dart';


class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerInitial()) {
    on<LoadAllCustomers>((event, emit) async {
      final customers = await DatabaseHelper().getAllCustomers();
      emit(CustomerLoaded(customers: customers));
    });

    on<AddCustomer>((event, emit) async {
      await DatabaseHelper().insertCustomer(event.customer.toJson());
      emit(CustomerAdded());
      add(LoadAllCustomers());
    });

    on<DeleteCustomer>((event, emit) async {
      await DatabaseHelper().deleteCustomer(event.customerId);
      emit(CustomerDeleted());
      add(LoadAllCustomers());
    });
  }
}
