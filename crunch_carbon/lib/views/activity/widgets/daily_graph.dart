import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyGraph extends StatefulWidget {
  const DailyGraph({
    Key? key,
  }) : super(key: key);

  @override
  State<DailyGraph> createState() => _DailyGraphState();
}

class _DailyGraphState extends State<DailyGraph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Total Carbon Footprint',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              '0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Carbon Used',
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: LineChartSample2()),
        ],
      ),
    );
  }
}

class LineChartSample2 extends StatelessWidget {
  final bool showAvg;
  final List<FlSpot> spots = [
    FlSpot(0, 300),
    FlSpot(2, 250),
    FlSpot(4, 510),
    FlSpot(6, 300),
    FlSpot(8, 400),
    FlSpot(10, 200),
    FlSpot(11, 250),
  ];

  final List<Color> gradientColors = [
    const Color(0xff147AD6),
    Colors.transparent,
  ];

  final List<Color> lineColor = [
    const Color(0xff147AD6),
    const Color(0xff147AD6),
  ];

  List<Color> lineColors() {
    List<Color> tbr = [];
    for (FlSpot s in spots) {
      if (s.y > 500) {
        tbr.add(Colors.red);
      } else if (s.y > 300) {
        tbr.add(Colors.yellow);
      } else {
        tbr.add(Colors.green);
      }
    }
    return tbr;
  }

  LineChartSample2({Key? key, this.showAvg = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white,
          getTooltipItems: (touchedSpots) {
            return [
              LineTooltipItem(
                touchedSpots.first.y.toString().substring(
                        0, touchedSpots.first.y.toString().indexOf('.')) +
                    ' Carbon Used',
                TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ];
          },
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return [
            TouchedSpotIndicatorData(
              FlLine(
                color: Colors.transparent,
                strokeWidth: 1,
              ),
              FlDotData(
                getDotPainter: (spot, dou, lbd, inttt) {
                  return FlDotCirclePainter(
                    color: const Color(0xff147AD6),
                    radius: 2,
                    strokeColor: const Color(0xff147AD6),
                    strokeWidth: 1,
                  );
                },
              ),
            )
          ];
        },
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          interval: 100,
          getTitles: (value) {
            switch (value.toInt()) {
              case 100:
                return '100';
              case 300:
                return '300';
              case 500:
                return '500';
            }
            return '';
          },
          reservedSize: 28,
          margin: 20,
        ),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 500,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: lineColor,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
            getDotPainter: (spot, dou, lbd, inttt) {
              return FlDotCirclePainter(
                color: const Color(0xff147AD6),
                radius: 2,
                strokeColor: const Color(0xff147AD6),
                strokeWidth: 1,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            gradientFrom: Offset(0.5, 0),
            gradientTo: Offset(0.5, 1),
          ),
        ),
      ],
    );
  }
}
