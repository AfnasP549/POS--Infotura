import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';
import 'package:pos/models/sale.dart';
import 'package:pos/services/database_service.dart';

part 'sale_event.dart';
part 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final DatabaseService _dataBaseService;

  SaleBloc(this._dataBaseService) : super(SaleInitial()) {
    on<AddSale>((event, emit) async {
      emit(SaleLoading());
      try {
        final sale = Sale(
          itemName: event.itemName,
          amount: event.amount,
          timestamp: DateTime.now(),
        );
        await _dataBaseService.addSale(sale);
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult != ConnectivityResult.none) {
          await _dataBaseService.syncSales();
        }
        emit(SalesSuccess());
      } catch (e) {
        emit(SaleError('Sales Add error: ${e.toString()}'));
      }
    });

    on<FetchSales>((event, emit) async {
      emit(SaleLoading());
      try {
        final sales = await _dataBaseService.getSales();
        emit(SalesLoaded(sales));
      } catch (e) {
        emit(SaleError('Sales fetching error:${e.toString()}'));
      }
    });

    on<SyncSales>((event, emit) async {
      try {
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult != ConnectivityResult.none) {
          await _dataBaseService.syncSales();
        }
      } catch (e) {
        emit(SaleError('Sales syncing error:${e.toString()}'));
      }
    });
  }
}
