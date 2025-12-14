import 'package:flutter/material.dart';
import 'package:sales_matrix_app/bloc/app_bloc_providers.dart';
import 'package:sales_matrix_app/view/dashboard/sales_dashboard_screen.dart';
import 'package:sales_matrix_app/view/invoice/invoice_compare_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // Add New Application

  @override
  Widget build(BuildContext context) {
    return appBlocProviders(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (_) => const SalesDashboardScreen(),
          '/invoice': (_) => const InvoiceCompareScreen(),
        },
      ),
    );
  }
}
