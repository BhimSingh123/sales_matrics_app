import '../data/models/sale_model.dart';

Map<String, double> getMonthlySales(List<SaleModel> sales) {
  final Map<String, double> result = {};

  for (var sale in sales) {
    final key = "${sale.date.year}-${sale.date.month}";
    result[key] = (result[key] ?? 0) + sale.salesAmount;
  }

  return result;
}

Map<String, int> getActiveStoresByRegion(List<SaleModel> sales) {
  final Map<String, int> result = {};

  for (var sale in sales) {
    if (sale.isActiveStore) {
      result[sale.region] = (result[sale.region] ?? 0) + 1;
    }
  }

  return result;
}
