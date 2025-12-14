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
      date: DateTime.parse(json['date']),
      brand: json['brand'],
      region: json['region'],
      salesAmount: (json['salesAmount'] as num).toDouble(),
      isActiveStore: json['isActiveStore'],
    );
  }
}
