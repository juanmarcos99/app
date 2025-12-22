import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

     
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                minY: 0,
                barTouchData: BarTouchData(enabled: true),

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          "Ene", "Feb", "Mar", "Abr", "May", "Jun",
                          "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
                        ];
                        return Text(
                          months[value.toInt()],
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),

                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),

                barGroups: [
                  _bar(0, 3, Colors.red),
                  _bar(1, 5, Colors.orange),
                  _bar(2, 2, Colors.yellow),
                  _bar(3, 6, Colors.green),
                  _bar(4, 4, Colors.teal),
                  _bar(5, 7, Colors.blue),
                  _bar(6, 5, Colors.indigo),
                  _bar(7, 8, Colors.purple),
                  _bar(8, 6, Colors.pink),
                  _bar(9, 9, Colors.brown),
                  _bar(10, 7, Colors.cyan),
                  _bar(11, 4, Colors.lime),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
