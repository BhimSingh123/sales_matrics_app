import 'package:sales_matrix_app/data/models/invoice_comparison_result.dart';

import '../../data/models/invoice_item_model.dart';

abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final List<InvoiceItemModel> poItems;
  final List<InvoiceItemModel> invoiceItems;

  InvoiceLoaded({
    required this.poItems,
    required this.invoiceItems,
  });
}

class InvoiceCompared extends InvoiceState {
  final List<InvoiceComparisonResult> results;

  InvoiceCompared(this.results);
}

class InvoiceError extends InvoiceState {
  final String message;
  InvoiceError(this.message);
}
