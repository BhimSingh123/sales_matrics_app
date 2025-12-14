import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlySalesChart extends StatelessWidget {
  final Map<String, double> data;

  const MonthlySalesChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final spots = data.entries.toList().asMap().entries.map(
      (e) {
        return FlSpot(
          e.key.toDouble(),
          e.value.value,
        );
      },
    ).toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
