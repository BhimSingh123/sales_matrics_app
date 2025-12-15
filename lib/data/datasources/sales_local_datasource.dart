import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/sale_model.dart';
import 'package:hive/hive.dart';

class SalesLocalDataSource {
  final _box = Hive.box('sales_cache');

  Future<List<SaleModel>> loadSales() async {
    final cached = _box.get('sales');

    if (cached != null && cached is List) {
      return cached
          .where((e) => e != null)
          .map((e) => SaleModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    }

    final jsonString = await rootBundle.loadString('assets/data/sales.json');
    final decoded = json.decode(jsonString);

    if (decoded is! List) {
      throw Exception('Invalid sales JSON format');
    }

    final sales = decoded
        .where((e) => e != null)
        .map((e) => SaleModel.fromJson(
              Map<String, dynamic>.from(e),
            ))
        .toList();

    await _box.put(
      'sales',
      sales.map((e) => e.toJson()).toList(),
    );

    return sales;
  }
}
