import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../../bloc/invoice_compare/invoice_bloc.dart';
import '../../bloc/invoice_compare/invoice_event.dart';
import '../../bloc/invoice_compare/invoice_state.dart';

class InvoiceCompareScreen extends StatelessWidget {
  const InvoiceCompareScreen({super.key});

  Future<void> _pickPoPdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // ignore: use_build_context_synchronously
      context
          .read<InvoiceBloc>()
          .add(LoadPoPdf(result.files.single.path!));
    }
  }

  Future<void> _pickInvoicePdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // ignore: use_build_context_synchronously
      context
          .read<InvoiceBloc>()
          .add(LoadInvoicePdf(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Comparison')),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _pickPoPdf(context),
                  child: const Text('Select Purchase Order PDF'),
                ),
                ElevatedButton(
                  onPressed: () => _pickInvoicePdf(context),
                  child: const Text('Select Invoice PDF'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<InvoiceBloc>().add(CompareInvoices());
                  },
                  child: const Text('Compare'),
                ),
                const SizedBox(height: 16),

                // RESULT VIEW
                Expanded(
                  child: _buildResult(state),
                ),
              ],
            ),
          );
        },
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

      return ListView.builder(
        itemCount: state.results.length,
        itemBuilder: (_, index) {
          final r = state.results[index];
          return ListTile(
            title: Text(r.poItem.itemCode),
            subtitle: Text(
              'PO Qty: ${r.poItem.quantity} | Invoice Qty: ${r.invoiceItem.quantity}',
            ),
            trailing: Icon(
              r.quantityMismatch ? Icons.error : Icons.check_circle,
              color: r.quantityMismatch ? Colors.red : Colors.green,
            ),
          );
        },
      );
    }

    return const Center(
      child: Text('Select both PDFs and click Compare'),
    );
  }
}
