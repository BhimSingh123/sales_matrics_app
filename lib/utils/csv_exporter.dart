import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../data/models/invoice_comparison_result.dart';

class CsvExporter {
  static Future<File> exportInvoiceComparison(
      List<InvoiceComparisonResult> results) async {
    final buffer = StringBuffer();

    // CSV Header
    buffer.writeln(
      'Item Code,PO Quantity,Invoice Quantity,PO Price,Invoice Price,Quantity Mismatch,Price Mismatch',
    );

    // CSV Rows
    for (final r in results) {
      buffer.writeln(
        '${r.poItem.itemCode},'
        '${r.poItem.quantity},'
        '${r.invoiceItem.quantity},'
        '${r.poItem.unitPrice},'
        '${r.invoiceItem.unitPrice},'
        '${r.quantityMismatch},'
        '${r.priceMismatch}',
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/invoice_comparison_report.csv');

    return file.writeAsString(buffer.toString());
  }
}
