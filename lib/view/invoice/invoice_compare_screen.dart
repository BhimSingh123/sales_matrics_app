// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sales_matrix_app/view/common/pdf_viwer_screen.dart';
import '../../bloc/invoice_compare/invoice_bloc.dart';
import '../../bloc/invoice_compare/invoice_event.dart';
import '../../bloc/invoice_compare/invoice_state.dart';
import '../../utils/csv_exporter.dart';

class InvoiceCompareScreen extends StatefulWidget {
  const InvoiceCompareScreen({super.key});

  @override
  State<InvoiceCompareScreen> createState() => _InvoiceCompareScreenState();
}

class _InvoiceCompareScreenState extends State<InvoiceCompareScreen> {
  String? poFileName;
  String? invoiceFileName;


    String? poFilePath;
String? invoiceFilePath;

  Future<void> _pickPoPdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        poFileName = result.files.single.name;
        poFilePath = result.files.single.path;
      });

      context.read<InvoiceBloc>().add(LoadPoPdf(result.files.single.path!));
    }
  }

  Future<void> _pickInvoicePdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        invoiceFileName = result.files.single.name;
        invoiceFilePath = result.files.single.path!;

      });

      context
          .read<InvoiceBloc>()
          .add(LoadInvoicePdf(result.files.single.path!));
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Invoice Comparison'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _fileSelectorCard(
                  title: 'Purchase Order PDF',
                  fileName: poFileName,
                  filePath: poFilePath,
                  onSelect: () => _pickPoPdf(context),
                ),
                const SizedBox(height: 12),
                _fileSelectorCard(
                  title: 'Invoice PDF',
                  fileName: invoiceFileName,
                  filePath: invoiceFilePath,
                  onSelect: () => _pickInvoicePdf(context),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.compare_arrows),
                    label: const Text('Compare Invoices'),
                    onPressed: () {
                      context.read<InvoiceBloc>().add(CompareInvoices());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildResult(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- UI Components ----------------

  Widget _fileSelectorCard({
    required String title,
    required String? fileName,
    required String? filePath,
    required VoidCallback onSelect,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    fileName ?? 'No file selected',
                    style: TextStyle(
                      fontSize: 13,
                      color: fileName == null ? Colors.grey : Colors.green[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // if (filePath != null)
            //   IconButton(
            //     icon: const Icon(Icons.visibility),
            //     tooltip: 'View PDF',
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) => PdfViewerScreen(
            //             filePath: filePath,
            //             title: title,
            //           ),
            //         ),
            //       );
            //     },
            //   ),
           
           
            TextButton(
              onPressed: onSelect,
              child: const Text('Select'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(InvoiceState state) {
    if (state is InvoiceLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is InvoiceCompared) {
      if (state.results.isEmpty) {
        return const Center(child: Text('No comparison data found'));
      }

      return Column(
        children: [
          Row(
            children: [
              const Text(
                'Comparison Results',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              OutlinedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Export CSV'),
                onPressed: () async {
                  final file =
                      await CsvExporter.exportInvoiceComparison(state.results);

                  // ignore: unnecessary_null_comparison
                  if (file != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('CSV saved at:\n${file!.path}'),
                          duration: const Duration(seconds: 5)),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: state.results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final r = state.results[index];
                final isMismatch = r.quantityMismatch || r.priceMismatch;

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isMismatch ? Colors.red : Colors.green,
                      child: Icon(
                        isMismatch ? Icons.error : Icons.check,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(r.poItem.itemCode,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'PO: Qty ${r.poItem.quantity}, Price ${r.poItem.unitPrice}'),
                        Text(
                            'Invoice: Qty ${r.invoiceItem.quantity}, Price ${r.invoiceItem.unitPrice}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return const Center(
      child: Text(
        'Select both PDFs and compare',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
