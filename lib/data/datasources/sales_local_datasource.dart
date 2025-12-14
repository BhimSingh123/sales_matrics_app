import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/sale_model.dart';

class SalesLocalDataSource {
  Future<List<SaleModel>> loadSales() async {
    final jsonString =
        await rootBundle.loadString('assets/data/sales.json');

    final List list = json.decode(jsonString);

    return list.map((e) => SaleModel.fromJson(e)).toList();
  }
}
