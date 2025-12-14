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

    print('PDF TEXT START ----------------');
    print(extractedText);
    print('PDF TEXT END ------------------');

    document.dispose();

    return _parseTextToItems(extractedText, source);
  }

  List<InvoiceItemModel> _parseTextToItems(
    String text,
    InvoiceSource source,
  ) {
    final lines = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final List<InvoiceItemModel> items = [];

    for (int i = 1; i < lines.length; i++) {
      if (lines[i].startsWith('ITEM')) {
        // Safety check: ensure next 4 lines exist
        if (i + 4 >= lines.length) continue;

        final itemCode = lines[i];
        final description = lines[i + 1];
        final quantity = int.tryParse(lines[i + 2]) ?? 0;
        final unitPrice = double.tryParse(lines[i + 3]) ?? 0;
        final totalPrice = double.tryParse(lines[i + 4]) ?? 0;

        items.add(
          InvoiceItemModel(
            itemCode: itemCode,
            description: description,
            quantity: quantity,
            unitPrice: unitPrice,
            totalPrice: totalPrice,
            source: source,
          ),
        );

        // Skip next 4 lines since they are already processed
        // i += 0;
      }
    }

    return items;
  }
}
