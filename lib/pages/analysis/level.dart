import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StrengthLevelBarChart extends StatelessWidget {
  final int beginnerCount;
  final int intermediateCount;
  final int advancedCount;

  const StrengthLevelBarChart({super.key, 
    required this.beginnerCount,
    required this.intermediateCount,
    required this.advancedCount,
  });

  @override
  Widget build(BuildContext context) {
    final List<StrengthData> chartData = [
      StrengthData('Beginner', beginnerCount),
      StrengthData('Intermediate', intermediateCount),
      StrengthData('Advanced', advancedCount),
    ];

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Strength Level Distribution'),
      legend: Legend(isVisible: false),
      series: <ChartSeries>[
        ColumnSeries<StrengthData, String>(
          dataSource: chartData,
          xValueMapper: (StrengthData data, _) => data.level,
          yValueMapper: (StrengthData data, _) => data.count,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
    );
  }
}

class StrengthData {
  final String level;
  final int count;

  StrengthData(this.level, this.count);
}
