import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/local/db_service.dart';

part 'bill_event.dart';
part 'bill_state.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  BillBloc() : super(BillInitial()) {
    // on<BillEvent>((event, emit) {});
    on<LoadDayGraph>((event, emit) => emit(GraphState([], 0)));
    on<LoadWeekGraph>((event, emit) => emit(GraphState([], 0)));
    on<LoadMonthGraph>((event, emit) => emit(GraphState([], 0)));

    on<LoadAllSales>((event, emit) async {
      final sales = await _dbHelper.getAllSales();
      emit(AllSalesState(sales));
    });

    on<LoadAllPrintableSales>((event, emit) async {
      final sales = await _dbHelper.getAllPrintableSales();
      emit(AllSalesState(sales));
    });
  }
}
