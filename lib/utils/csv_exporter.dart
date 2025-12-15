import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../data/models/invoice_comparison_result.dart';

class CsvExporter {
  static Future<File> exportInvoiceComparison(
      List<InvoiceComparisonResult> results) async {
    final buffer = StringBuffer();

    buffer.writeln(
      'Item Code,PO Quantity,Invoice Quantity,PO Price,Invoice Price,Quantity Mismatch,Price Mismatch',
    );

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

    // ✅ Correct external directory (scoped storage safe)
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception('External storage not available');
    }

    final filePath =
        '${directory.path}/invoice_comparison_report_${DateTime.now().millisecondsSinceEpoch}.csv';

    final file = File(filePath);
    await file.writeAsString(buffer.toString());

    print('CSV SAVED AT: $filePath');

    return file;
  }
}
