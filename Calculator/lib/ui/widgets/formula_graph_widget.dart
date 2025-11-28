import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:calculator_hub/features/custom_calculator/services/math_engine.dart';
import 'package:calculator_hub/features/custom_calculator/models/custom_calculator_model.dart';

class FormulaGraphWidget extends StatefulWidget {
  final String formula;
  final List<CalculatorVariable> variables;
  final Map<String, double> currentValues;
  final String xAxisVariable;

  const FormulaGraphWidget({
    super.key,
    required this.formula,
    required this.variables,
    required this.currentValues,
    required this.xAxisVariable,
  });

  @override
  State<FormulaGraphWidget> createState() => _FormulaGraphWidgetState();
}

class _FormulaGraphWidgetState extends State<FormulaGraphWidget> {
  List<FlSpot> _spots = [];
  bool _isLoading = false;
  String? _error;
  double _minY = 0;
  double _maxY = 0;

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  @override
  void didUpdateWidget(covariant FormulaGraphWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.formula != widget.formula ||
        oldWidget.xAxisVariable != widget.xAxisVariable ||
        oldWidget.currentValues != widget.currentValues) {
      _generateData();
    }
  }

  Future<void> _generateData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final spots = <FlSpot>[];
      // Determine range for X-axis
      // If the variable has min/max, use them. Otherwise default to 0-100.
      final xVar = widget.variables.firstWhere((v) => v.name == widget.xAxisVariable);
      double minX = xVar.min ?? 0;
      double maxX = xVar.max ?? (minX + 100);
      
      // If range is too small (e.g. single point), expand it slightly
      if (maxX <= minX) maxX = minX + 10;

      final step = (maxX - minX) / 50; // 50 points

      double minY = double.infinity;
      double maxY = double.negativeInfinity;

      for (double x = minX; x <= maxX; x += step) {
        // Prepare variables for this point
        final pointVars = Map<String, double>.from(widget.currentValues);
        pointVars[widget.xAxisVariable] = x;

        try {
          final result = MathEngine.evaluate(widget.formula, pointVars);
          if (result.isSuccess) {
            final val = result.value!;
            if (val.isFinite) {
              spots.add(FlSpot(x, val));
              if (val < minY) minY = val;
              if (val > maxY) maxY = val;
            }
          }
        } catch (e) {
          // Ignore points that fail to evaluate
        }
      }


      if (spots.isEmpty) {
        throw Exception('No valid data points generated.');
      }

      // Add some padding to Y axis
      final yRange = maxY - minY;
      if (yRange == 0) {
        minY -= 1;
        maxY += 1;
      } else {
        minY -= yRange * 0.1;
        maxY += yRange * 0.1;
      }

      setState(() {
        _spots = spots;
        _minY = minY;
        _maxY = maxY;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Cannot plot graph: $_error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_spots.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Colors.white10,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Colors.white10,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (_spots.last.x - _spots.first.x) / 5,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: _spots.first.x,
          maxX: _spots.last.x,
          minY: _minY,
          maxY: _maxY,
          lineBarsData: [
            LineChartBarData(
              spots: _spots,
              isCurved: true,
              gradient: const LinearGradient(
                colors: [
                  Colors.cyanAccent,
                  Colors.blueAccent,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.cyanAccent.withOpacity(0.3),
                    Colors.blueAccent.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
