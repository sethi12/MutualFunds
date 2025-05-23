import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/fund.dart';

class FundDetailScreen extends StatelessWidget {
  final MutualFund fund;

  const FundDetailScreen({required this.fund, Key? key}) : super(key: key);

  List<FlSpot> get navSpots {
    return List.generate(fund.navHistory.length,
        (index) => FlSpot(index.toDouble(), fund.navHistory[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fund.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('NAV History', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 200, child: LineChart(_buildLineChart())),
            SizedBox(height: 24),
            Text('Monthly Returns Heatmap',
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 150, child: _buildHeatmap(context)),
          ],
        ),
      ),
    );
  }

  LineChartData _buildLineChart() {
    return LineChartData(
      minX: 0,
      maxX: (fund.navHistory.length - 1).toDouble(),
      minY: fund.navHistory.reduce((a, b) => a < b ? a : b),
      maxY: fund.navHistory.reduce((a, b) => a > b ? a : b),
      lineBarsData: [
        LineChartBarData(
          spots: navSpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: FlDotData(show: false),
        )
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
      gridData: FlGridData(show: true),
    );
  }

  Widget _buildHeatmap(BuildContext context) {
    Color colorForReturn(double value) {
      if (value > 0) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: fund.monthlyReturns.entries.map((entry) {
        return Container(
          width: (MediaQuery.of(context).size.width - 64) /
              4, // 4 columns with padding
          height: 40,
          decoration: BoxDecoration(
            color: colorForReturn(entry.value),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(entry.key,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              Text('${entry.value.toStringAsFixed(2)}%',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
