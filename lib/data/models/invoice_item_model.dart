class InvoiceItemModel {
  final String itemCode;
  final String description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final InvoiceSource source;

  InvoiceItemModel({
    required this.itemCode,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.source,
  });
}

enum InvoiceSource {
  purchaseOrder,
  invoice,
}
