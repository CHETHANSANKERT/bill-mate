import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/local/db_service.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  StoreBloc() : super(StoreInitial()) {
    on<StoreEvent>((event, emit) {});

    on<LoadAllStores>((event, emit) async {
      final allStores = await _dbHelper.getAllStores();
      emit(AllStoresState(allStores));
    });

  }
}
