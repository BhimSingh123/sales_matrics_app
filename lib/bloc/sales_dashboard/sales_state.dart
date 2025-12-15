import 'package:sales_matrix_app/data/models/sale_model.dart';

abstract class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesLoaded extends SalesState {
  final List<SaleModel> sales;
  final double totalSales;
  final int activeStores;
  final String topBrand;

  SalesLoaded({
    required this.sales,
    required this.totalSales,
    required this.activeStores,
    required this.topBrand,
  });
}

class SalesError extends SalesState {
  final String message;

  SalesError(this.message);
}
