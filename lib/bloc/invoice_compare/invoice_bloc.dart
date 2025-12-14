import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_matrix_app/data/datasources/pdf_local_datasource.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';
import '../../data/models/invoice_item_model.dart';
import '../../data/models/invoice_comparison_result.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final PdfLocalDataSource dataSource;

  List<InvoiceItemModel> _poItems = [];
  List<InvoiceItemModel> _invoiceItems = [];

  InvoiceBloc(this.dataSource) : super(InvoiceInitial()) {
    on<LoadPoPdf>(_loadPo);
    on<LoadInvoicePdf>(_loadInvoice);
    on<CompareInvoices>(_compare);
  }

  Future<void> _loadPo(LoadPoPdf event, Emitter<InvoiceState> emit) async {
    emit(InvoiceLoading());
    _poItems = await dataSource.parsePdf(
      event.filePath,
      InvoiceSource.purchaseOrder,
    );
    emit(InvoiceLoaded(poItems: _poItems, invoiceItems: _invoiceItems));
  }

  Future<void> _loadInvoice(
      LoadInvoicePdf event, Emitter<InvoiceState> emit) async {
    emit(InvoiceLoading());
    _invoiceItems = await dataSource.parsePdf(
      event.filePath,
      InvoiceSource.invoice,
    );
    emit(InvoiceLoaded(poItems: _poItems, invoiceItems: _invoiceItems));
  }

  void _compare(CompareInvoices event, Emitter<InvoiceState> emit) {
    final Map<String, InvoiceItemModel> poMap = {
      for (var item in _poItems) item.itemCode: item
    };

    final Map<String, InvoiceItemModel> invoiceMap = {
      for (var item in _invoiceItems) item.itemCode: item
    };

    final Set<String> allItemCodes = {
      ...poMap.keys,
      ...invoiceMap.keys,
    };

    final List<InvoiceComparisonResult> results = [];

    for (final code in allItemCodes) {
      final poItem = poMap[code];
      final invoiceItem = invoiceMap[code];

      if (poItem == null || invoiceItem == null) continue;

      results.add(
        InvoiceComparisonResult(
          poItem: poItem,
          invoiceItem: invoiceItem,
          quantityMismatch: poItem.quantity != invoiceItem.quantity,
          priceMismatch: poItem.unitPrice != invoiceItem.unitPrice,
        ),
      );
    }

    emit(InvoiceCompared(results));
  }
}
