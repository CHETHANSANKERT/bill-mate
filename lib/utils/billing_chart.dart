import 'package:bill_mate/components/ui/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/asset_constants.dart';

class BillingChart extends StatelessWidget {
  final List<MapEntry<String, double>> data;

  const BillingChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: SvgPicture.asset(
            GeneralImageAssets.noDataAvailable,
            height: 200,
          ),
        ),
      );
    }

    final yValues = data.map((e) => e.value).toList();
    final xLabels = data.map((e) => e.key).toList();

    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final maxY = yValues.reduce((a, b) => a > b ? a : b);

    final intervalY = ((maxY - minY) / 5).ceilToDouble();
    final double yInterval = intervalY <= 0 ? 1.0 : intervalY;

    final xIndexesToShow = _getXLabelIndexes(data.length);

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: yInterval,
                getTitlesWidget: (value, meta) => Padding(
                  padding: EdgeInsets.only(right: 2.h),
                  child: Text(
                    '${value.toInt()}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (!xIndexesToShow.contains(index)) {
                    return const SizedBox.shrink();
                  }
                  if (index < 0 || index >= xLabels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      DateTime.parse(xLabels[index]).day.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: minY,
          maxY: maxY + yInterval / 2,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: AppColors.kCardBg,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    "\$${spot.y.toStringAsFixed(2)}",
                    const TextStyle(color: Colors.black),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (index) => FlSpot(index.toDouble(), data[index].value),
              ),
              isCurved: true,
              barWidth: 3,
              color: AppColors.kBlue,
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.kBlue.withOpacity(0.3),
              ),
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  /// Utility to calculate which indexes to show on x-axis
  List<int> _getXLabelIndexes(int length) {
    if (length <= 5) return List.generate(length, (i) => i);

    const first = 0;
    final last = length - 1;
    final step = (length / 4).floor();

    return [
      first,
      first + step,
      first + step * 2,
      first + step * 3,
      last,
    ];
  }
}
