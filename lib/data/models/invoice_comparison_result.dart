import 'invoice_item_model.dart';

class InvoiceComparisonResult {
  final InvoiceItemModel poItem;
  final InvoiceItemModel invoiceItem;
  final bool quantityMismatch;
  final bool priceMismatch;

  InvoiceComparisonResult({
    required this.poItem,
    required this.invoiceItem,
    required this.quantityMismatch,
    required this.priceMismatch,
  });
}
