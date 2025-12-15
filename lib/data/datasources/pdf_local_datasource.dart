import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/invoice_item_model.dart';

class PdfLocalDataSource {
  Future<List<InvoiceItemModel>> parsePdf(
    String filePath,
    InvoiceSource source,
  ) async {
    final fileBytes = File(filePath).readAsBytesSync();

    final PdfDocument document = PdfDocument(inputBytes: fileBytes);

    final PdfTextExtractor extractor = PdfTextExtractor(document);
    final String extractedText = extractor.extractText();


    document.dispose();

    return parseClientInvoicePdf(extractedText, source);
  }
List<InvoiceItemModel> parseClientInvoicePdf(
  String extractedText,
  InvoiceSource source,
) {
  final lines = extractedText
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  final List<InvoiceItemModel> items = [];

  bool isSku(String value) {
    return RegExp(r'^A\d{4}$').hasMatch(value);
  }

  int i = 0;
  while (i < lines.length) {
    if (isSku(lines[i])) {
      final sku = lines[i];
      if (i + 2 >= lines.length) break;

      final description = lines[i + 1];

      int? quantity;
      double? unitPrice;
      double? lineTotal;

      int j = i + 2;

      // Scan forward until next SKU or end
      while (j < lines.length && !isSku(lines[j])) {
        final value = lines[j];

        if (quantity == null && int.tryParse(value) != null) {
          quantity = int.parse(value);
        } else if (unitPrice == null && double.tryParse(value) != null) {
          unitPrice = double.parse(value);
        }

        if (double.tryParse(value) != null) {
          lineTotal = double.parse(value);
        }

        j++;
      }

      items.add(
        InvoiceItemModel(
          itemCode: sku,
          description: description,
          quantity: quantity ?? 0,
          unitPrice: unitPrice ?? 0,
          totalPrice: lineTotal ?? 0,
          source: source,
        ),
      );

      i = j; // jump to next SKU block
    } else {
      i++;
    }
  }

  return items;
}
}
