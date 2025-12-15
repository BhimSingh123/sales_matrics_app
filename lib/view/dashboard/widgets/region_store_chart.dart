import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RegionStoreChart extends StatelessWidget {
  final Map<String, int> data;

  const RegionStoreChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bars = data.entries.toList().asMap().entries.map(
      (e) {
        return BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: e.value.value.toDouble(),
              color: Colors.orange,
              borderRadius: BorderRadius.circular(6),
              width: 18,
            )
          ],
        );
      },
    ).toList();

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          barGroups: bars,
        ),
      ),
    );
  }
}
