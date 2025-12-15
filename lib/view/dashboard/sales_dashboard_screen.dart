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
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Sales Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<SalesBloc, SalesState>(
        builder: (context, state) {
          if (state is SalesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SalesLoaded) {
            final monthlySales = getMonthlySales(state.sales);
            final regionStores = getActiveStoresByRegion(state.sales);

            final currentYear = DateTime.now().year;
            final lastYear = currentYear - 1;

            final currentYearSales =
                getYearlySales(state.sales, currentYear);
            final lastYearSales =
                getYearlySales(state.sales, lastYear);

            final yoyGrowth = lastYearSales == 0
                ? 0
                : ((currentYearSales - lastYearSales) /
                        lastYearSales) *
                    100;

            final brands =
                state.sales.map((e) => e.brand).toSet().toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ================= KPI ROW =================
                  Row(
                    children: [
                      _kpiCard(
                        title: 'Total Sales',
                        value: '₹${state.totalSales.toStringAsFixed(0)}',
                        icon: Icons.trending_up,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      _kpiCard(
                        title: 'Active Stores',
                        value: '${state.activeStores}',
                        icon: Icons.store,
                        color: Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _kpiCard(
                        title: 'Top Brand',
                        value: state.topBrand,
                        icon: Icons.star,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      _kpiCard(
                        title: 'YoY Growth',
                        value: '${yoyGrowth.toStringAsFixed(1)}%',
                        icon: Icons.show_chart,
                        color: yoyGrowth >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ================= BRAND FILTER =================
                  Align(
                    alignment: Alignment.centerLeft,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Filter by Brand',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: brands
                          .map(
                            (b) => DropdownMenuItem(
                              value: b,
                              child: Text(b),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        context
                            .read<SalesBloc>()
                            .add(ApplySalesFilter(brand: value));
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= CHARTS =================
                  _sectionCard(
                    title: 'Monthly Sales Trend',
                    child: MonthlySalesChart(data: monthlySales),
                  ),

                  const SizedBox(height: 20),

                  _sectionCard(
                    title: 'Active Stores by Region',
                    child: RegionStoreChart(data: regionStores),
                  ),

                  const SizedBox(height: 30),

                  // ================= NAVIGATION =================
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/invoice');
                    },
                    icon: const Icon(Icons.compare),
                    label: const Text('Open Invoice Comparison'),
                  ),
                ],
              ),
            );
          }

          if (state is SalesError) {
            return Center(child: Text(state.message));
          }

          return Center(
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<SalesBloc>().add(LoadSalesData());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Load Sales Data'),
                ),

                    // ================= NAVIGATION =================
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/invoice');
                    },
                    icon: const Icon(Icons.compare),
                    label: const Text('Open Invoice Comparison'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _kpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

