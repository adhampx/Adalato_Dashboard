import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StrengthLevelByGenderChart extends StatelessWidget {
  final int maleBeginnerCount;
  final int maleIntermediateCount;
  final int maleAdvancedCount;
  final int femaleBeginnerCount;
  final int femaleIntermediateCount;
  final int femaleAdvancedCount;

  const StrengthLevelByGenderChart({super.key, 
    required this.maleBeginnerCount,
    required this.maleIntermediateCount,
    required this.maleAdvancedCount,
    required this.femaleBeginnerCount,
    required this.femaleIntermediateCount,
    required this.femaleAdvancedCount,
  });

  @override
  Widget build(BuildContext context) {
    final List<StrengthByGenderData> maleData = [
      StrengthByGenderData('Beginner', maleBeginnerCount),
      StrengthByGenderData('Intermediate', maleIntermediateCount),
      StrengthByGenderData('Advanced', maleAdvancedCount),
    ];

    final List<StrengthByGenderData> femaleData = [
      StrengthByGenderData('Beginner', femaleBeginnerCount),
      StrengthByGenderData('Intermediate', femaleIntermediateCount),
      StrengthByGenderData('Advanced', femaleAdvancedCount),
    ];

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Strength Level Distribution by Gender'),
      legend: Legend(isVisible: true),
      series: <ChartSeries>[
        StackedColumnSeries<StrengthByGenderData, String>(
          name: 'Male',
          dataSource: maleData,
          xValueMapper: (StrengthByGenderData data, _) => data.level,
          yValueMapper: (StrengthByGenderData data, _) => data.count,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        StackedColumnSeries<StrengthByGenderData, String>(
          name: 'Female',
          dataSource: femaleData,
          xValueMapper: (StrengthByGenderData data, _) => data.level,
          yValueMapper: (StrengthByGenderData data, _) => data.count,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class StrengthByGenderData {
  final String level;
  final int count;

  StrengthByGenderData(this.level, this.count);
}
