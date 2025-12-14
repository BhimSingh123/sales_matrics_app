import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_matrix_app/utils/chart_data_helper.dart';
import 'package:sales_matrix_app/view/dashboard/widgets/monthly_sales_chart.dart';
import 'package:sales_matrix_app/view/dashboard/widgets/region_store_chart.dart';
import '../../bloc/sales_dashboard/sales_bloc.dart';
import '../../bloc/sales_dashboard/sales_event.dart';
import '../../bloc/sales_dashboard/sales_state.dart';

class SalesDashboardScreen extends StatelessWidget {
  const SalesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Dashboard')),
      body: BlocBuilder<SalesBloc, SalesState>(
        builder: (context, state) {
          if (state is SalesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SalesLoaded) {
            final monthlySales = getMonthlySales(state.sales);
            final regionStores = getActiveStoresByRegion(state.sales);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('Total Sales: ₹${state.totalSales}'),
                    Text('Active Stores: ${state.activeStores}'),
                    const SizedBox(height: 20),
                    MonthlySalesChart(data: monthlySales),
                    const SizedBox(height: 20),
                    RegionStoreChart(data: regionStores),
                  ],
                ),
              ),
            );
          }

          if (state is SalesError) {
            return Center(child: Text(state.message));
          }

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<SalesBloc>().add(LoadSalesData());
                  },
                  child: const Text('Load Sales Data'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/invoice');
                  },
                  child: const Text('Open Invoice Comparison'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
