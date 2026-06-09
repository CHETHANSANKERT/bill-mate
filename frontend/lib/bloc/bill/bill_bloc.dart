import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/local/db_service.dart';

part 'bill_event.dart';
part 'bill_state.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  double monthlySaleTotal = 0;
  List<MapEntry<String, double>> saleMap = [];
  BillBloc() : super(BillInitial()) {
    on<LoadThisMonthGraph>((event, emit) async {
      final result = await DatabaseHelper().getCurrentMonthSales();
      /// for clearing the [monthlySaleTotal] and the preloaded [saleMap] on every tap
      monthlySaleTotal = 0.0;
      Map<String, double> saleMap = {};

      /// calculating total map and adding new date and total to the map and monthlySaleTotal
      for (final i in result) {
        final date = i['createdAt'].toString();
        final total = double.tryParse(i['saleTotal'].toString()) ?? 0.0;
        saleMap[date] = (saleMap[date] ?? 0.0) + total;
        monthlySaleTotal += total;
      }

      final saleEntries = saleMap.entries.toList();
      return emit(GraphState(saleEntries, monthlySaleTotal));
    });

    on<LoadLastMonthGraph>((event, emit) async {
      final result = await DatabaseHelper().getLastMonthSales();

      /// for clearing the [monthlySaleTotal] and the preloaded [saleMap] on every tap
      monthlySaleTotal = 0.0;
      Map<String, double> saleMap = {};

      /// calculating total map and adding new date and total to the map and monthlySaleTotal
      for (final i in result) {
        final date = i['createdAt'].toString();
        final total = double.tryParse(i['saleTotal'].toString()) ?? 0.0;
        saleMap[date] = (saleMap[date] ?? 0.0) + total;
        monthlySaleTotal += total;
      }

      final saleEntries = saleMap.entries.toList();
      return emit(GraphState(saleEntries, monthlySaleTotal));
    });

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
