import 'package:sales_matrix_app/data/models/invoice_item_model.dart';

class InvoiceComparisonModel {
  final InvoiceItemModel poItem;
  final InvoiceItemModel invoiceItem;
  final bool quantityMismatch;
  final bool priceMismatch;

  InvoiceComparisonModel({
    required this.poItem,
    required this.invoiceItem,
    required this.quantityMismatch,
    required this.priceMismatch,
  });
}
