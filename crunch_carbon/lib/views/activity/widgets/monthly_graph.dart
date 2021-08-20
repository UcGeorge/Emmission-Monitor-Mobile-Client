import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyGraph extends StatelessWidget {
  const MonthlyGraph({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '12300.23',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Monthly Usage',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: BarChartSample()),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 42,
              width: 114,
              margin: EdgeInsets.only(right: 20),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      // letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSampleState();
}

class BarChartSampleState extends State<BarChartSample> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
        // color: Color(0xff232d37),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 12),
        child: MyBarChart(),
      ),
    );
  }
}

class MyBarChart extends StatelessWidget {
  MyBarChart({
    Key? key,
  }) : super(key: key);

  final barRodData = BarChartRodData(
    y: 250,
    colors: [const Color(0xff147AD6)],
    width: 9.48,
    borderRadius: BorderRadius.circular(4),
  );

  final data = [
    2500,
    5000,
    7400,
    4000,
    5500,
    3000,
    4200,
    2500,
    5000,
    7400,
    4000,
    5500
  ];

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: 12000,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                rod.y.toString().substring(0, rod.y.toString().indexOf('.')) +
                    ' Carbon Used',
                TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // letterSpacing: 1.0,
                ),
              );
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 20,
          // checkToShowHorizontalLine: (value) => value == 480,
          getDrawingHorizontalLine: (value) {
            if (value == 5000) {
              return FlLine(
                color: const Color(0xff7C828A),
                strokeWidth: 1,
                dashArray: [1, 3],
              );
            }
            return FlLine(
              color: Colors.transparent,
              strokeWidth: 0.8,
            );
          },
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
            interval: 1000,
            getTitles: (value) {
              switch (value.toInt()) {
                // case 0:
                //   return '0';
                case 3000:
                  return '3000';
                // case 200:
                //   return '200';
                case 6000:
                  return '6000';
                // case 400:
                //   return '400';
                case 9000:
                  return '9000';
              }
              return '';
            },
            reservedSize: 28,
            margin: 20,
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            margin: 20,
            rotateAngle: 45,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'Jan';
                case 1:
                  return 'Feb';
                case 2:
                  return 'Mar';
                case 3:
                  return 'Apr';
                case 4:
                  return 'May';
                case 5:
                  return 'Jun';
                case 6:
                  return 'Jul';
                case 7:
                  return 'Aug';
                case 8:
                  return 'Sep';
                case 9:
                  return 'Oct';
                case 10:
                  return 'Nov';
                case 11:
                  return 'Dec';
                default:
                  return '';
              }
            },
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: data
            .map((e) => BarChartGroupData(
                  x: index++,
                  barRods: [
                    barRodData.copyWith(
                      y: e.toDouble(),
                      colors: [
                        e <= 5000
                            ? Color(0xff7388A9).withOpacity(0.35)
                            : const Color(0xff147AD6)
                      ],
                    )
                  ],
                  // showingTooltipIndicators: [0],
                ))
            .toList(),
      ),
    );
  }
}
