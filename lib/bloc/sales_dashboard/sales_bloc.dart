import 'package:flutter_bloc/flutter_bloc.dart';
import 'sales_event.dart';
import 'sales_state.dart';
import '../../data/models/sale_model.dart';
import '../../data/datasources/sales_local_datasource.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final SalesLocalDataSource dataSource;

  // All data (original)
  List<SaleModel> _allSales = [];

  SalesBloc(this.dataSource) : super(SalesInitial()) {
    on<LoadSalesData>(_onLoadSales);
    on<ApplySalesFilter>(_onApplyFilter);
  }

  // ================= LOAD SALES (Hive + JSON) =================
  Future<void> _onLoadSales(
      LoadSalesData event, Emitter<SalesState> emit) async {
    emit(SalesLoading());

    try {
      final sales = await dataSource.loadSales();

      _allSales = sales;

      emit(_buildLoadedState(sales));
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }

  // ================= APPLY BRAND FILTER =================
  void _onApplyFilter(
      ApplySalesFilter event, Emitter<SalesState> emit) {
    final filtered = event.brand == null
        ? _allSales
        : _allSales.where((e) => e.brand == event.brand).toList();

    emit(_buildLoadedState(filtered));
  }

  // ================= COMMON CALCULATIONS =================
  SalesLoaded _buildLoadedState(List<SaleModel> data) {
    final totalSales =
        data.fold<double>(0, (sum, e) => sum + e.salesAmount);

    final activeStores =
        data.where((e) => e.isActiveStore).length;

    final topBrand = _getTopBrand(data);

    return SalesLoaded(
      sales: data,
      totalSales: totalSales,
      activeStores: activeStores,
      topBrand: topBrand,
    );
  }

  // ================= TOP BRAND KPI =================
  String _getTopBrand(List<SaleModel> sales) {
    final Map<String, double> brandSales = {};

    for (final s in sales) {
      brandSales[s.brand] =
          (brandSales[s.brand] ?? 0) + s.salesAmount;
    }

    if (brandSales.isEmpty) return '-';

    return brandSales.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}
