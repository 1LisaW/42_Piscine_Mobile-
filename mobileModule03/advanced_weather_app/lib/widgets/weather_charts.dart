import 'dart:math' as math;

import 'package:advanced_weather_app/models/weather_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayTemperatureChart extends StatelessWidget {
  const TodayTemperatureChart({super.key, required this.data});

  final HourlyWeatherData data;

  @override
  Widget build(BuildContext context) {
    final n = data.hourlyTemperature.length;
    if (n < 2) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Not enough data for chart')),
      );
    }

    final temps = data.hourlyTemperature;
    double minT = temps.reduce(math.min);
    double maxT = temps.reduce(math.max);
    double pad = math.max(1.0, (maxT - minT) * 0.2);
    if (maxT - minT < 0.5) {
      pad = 2;
    }

    final spots = List<FlSpot>.generate(
      n,
      (i) => FlSpot(i.toDouble(), temps[i]),
    );

    final labelHour = DateFormat('HH:mm');

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxT - minT + 2 * pad) / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: (maxT - minT + 2 * pad) / 4,
                getTitlesWidget: (value, meta) => Text(
                  '${value.round()}°',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: math.max(1, n / 6).floorToDouble(),
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  if (i < 0 || i >= n) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labelHour.format(data.hourlyTime[i].toLocal()),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (n - 1).toDouble(),
          minY: minT - pad,
          maxY: maxT + pad,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFFFFB74D),
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFB74D).withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.black87,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((s) {
                  final i = s.x.round();
                  final t = i >= 0 && i < n ? temps[i] : s.y;
                  final h = i >= 0 && i < n
                      ? labelHour.format(data.hourlyTime[i].toLocal())
                      : '';
                  return LineTooltipItem(
                    '$h\n${t.toStringAsFixed(1)}°C',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class WeeklyMinMaxChart extends StatelessWidget {
  const WeeklyMinMaxChart({super.key, required this.data});

  final WeeklyWeatherData data;

  @override
  Widget build(BuildContext context) {
    final count = math.min(7, data.dailyTime.length);
    if (count < 2) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Not enough data for chart')),
      );
    }

    final mins = data.dailyTemperatureMin.take(count).toList();
    final maxs = data.dailyTemperatureMax.take(count).toList();
    final n = count;

    double low = mins.reduce(math.min);
    double high = maxs.reduce(math.max);
    double pad = math.max(1.0, (high - low) * 0.15);

    final dayFmt = DateFormat('EEE');

    final spotsMin = List<FlSpot>.generate(
      n,
      (i) => FlSpot(i.toDouble(), mins[i]),
    );
    final spotsMax = List<FlSpot>.generate(
      n,
      (i) => FlSpot(i.toDouble(), maxs[i]),
    );

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withValues(alpha: 0.12),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  '${value.round()}°',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  if (i < 0 || i >= n) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      dayFmt.format(data.dailyTime[i].toLocal()),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (n - 1).toDouble(),
          minY: low - pad,
          maxY: high + pad,
          lineBarsData: [
            LineChartBarData(
              spots: spotsMax,
              isCurved: true,
              color: const Color(0xFFFF8A65),
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),
            LineChartBarData(
              spots: spotsMin,
              isCurved: true,
              color: const Color(0xFF64B5F6),
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),
          ],
          lineTouchData: LineTouchData(enabled: true),
        ),
      ),
    );
  }
}
