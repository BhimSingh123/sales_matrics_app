class SaleModel {
  final DateTime date;
  final String brand;
  final String region;
  final double salesAmount;
  final bool isActiveStore;

  SaleModel({
    required this.date,
    required this.brand,
    required this.region,
    required this.salesAmount,
    required this.isActiveStore,
  });

factory SaleModel.fromJson(Map<String, dynamic> json) {
  return SaleModel(
    brand: json['brand'] ?? 'Unknown',
    region: json['region'] ?? 'NA',
    date: DateTime.tryParse(json['date'] ?? '') ??
        DateTime.now(),
    salesAmount:
        (json['salesAmount'] as num?)?.toDouble() ?? 0,
    isActiveStore: json['isActiveStore'] ?? false,
  );
}

  toJson() {}

}
