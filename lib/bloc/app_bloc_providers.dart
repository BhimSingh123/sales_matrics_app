import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_matrix_app/bloc/invoice_compare/invoice_bloc.dart';
import 'package:sales_matrix_app/bloc/sales_dashboard/sales_bloc.dart';
import 'package:sales_matrix_app/data/datasources/pdf_local_datasource.dart';
import 'package:sales_matrix_app/data/datasources/sales_local_datasource.dart';
import 'package:sales_matrix_app/utils/exports.dart';

Widget appBlocProviders({required Widget child}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => SalesBloc(SalesLocalDataSource())),
      BlocProvider(create: (_) => InvoiceBloc(PdfLocalDataSource())),
    ],
    child: child,
  );
}
