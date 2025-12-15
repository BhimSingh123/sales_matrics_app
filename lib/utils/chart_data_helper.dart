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

double getYearlySales(List<SaleModel> sales, int year) {
  return sales
      .where((s) => s.date.year == year)
      .fold(0.0, (sum, s) => sum + s.salesAmount);
}



Map<String, double> getSalesByBrand(List<SaleModel> sales) {
  final Map<String, double> result = {};

  for (var sale in sales) {
    result[sale.brand] = (result[sale.brand] ?? 0) + sale.salesAmount;
  }

  return result;
}
