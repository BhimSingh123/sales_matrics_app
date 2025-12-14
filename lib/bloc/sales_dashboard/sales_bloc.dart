import 'package:flutter_bloc/flutter_bloc.dart';
import 'sales_event.dart';
import 'sales_state.dart';
import '../../data/models/sale_model.dart';
import '../../data/datasources/sales_local_datasource.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final SalesLocalDataSource dataSource;

  List<SaleModel> _allSales = [];

  SalesBloc(this.dataSource) : super(SalesInitial()) {
    on<LoadSalesData>(_onLoadSales);
    on<ApplySalesFilter>(_onApplyFilter);
  }

  Future<void> _onLoadSales(
      LoadSalesData event, Emitter<SalesState> emit) async {
    emit(SalesLoading());

    try {
      _allSales = await dataSource.loadSales();
      _emitCalculatedState(_allSales, emit);
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }

  void _onApplyFilter(
      ApplySalesFilter event, Emitter<SalesState> emit) {
    final filtered = event.brand == null
        ? _allSales
        : _allSales.where((e) => e.brand == event.brand).toList();

    _emitCalculatedState(filtered, emit);
  }

  void _emitCalculatedState(
      List<SaleModel> data, Emitter<SalesState> emit) {
    final totalSales =
        data.fold<double>(0, (sum, e) => sum + e.salesAmount);

    final activeStores =
        data.where((e) => e.isActiveStore).length;

    emit(SalesLoaded(
      sales: data,
      totalSales: totalSales,
      activeStores: activeStores,
    ));
  }
}
