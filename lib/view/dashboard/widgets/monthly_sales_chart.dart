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
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
