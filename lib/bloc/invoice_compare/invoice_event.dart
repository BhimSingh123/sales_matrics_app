abstract class InvoiceEvent {}

class LoadPoPdf extends InvoiceEvent {
  final String filePath;
  LoadPoPdf(this.filePath);
}

class LoadInvoicePdf extends InvoiceEvent {
  final String filePath;
  LoadInvoicePdf(this.filePath);
}

class CompareInvoices extends InvoiceEvent {}
class ResetComparison extends InvoiceEvent {}