abstract class SalesEvent {}

class LoadSalesData extends SalesEvent {}

class ApplySalesFilter extends SalesEvent {
  final String? brand;

  ApplySalesFilter({this.brand});
}
class ClearSalesFilter extends SalesEvent {}