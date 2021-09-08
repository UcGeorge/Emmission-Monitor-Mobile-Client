import 'dart:io';

import 'package:crunch_carbon/models/session.dart';
import 'package:crunch_carbon/providers/ActivityProvider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeeklyGraph extends StatefulWidget {
  @override
  State<WeeklyGraph> createState() => _WeeklyGraphState();
}

class _WeeklyGraphState extends State<WeeklyGraph> {
  List<Session> sessionList = [];

  bool loading = true;

  void _initData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var username = prefs.getString('username');
    sessionList = await context.read<ActivityProvider>().getSessions(token ?? 'undefined', username ?? 'undefined');
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  final _screenshotController = ScreenshotController();

  void _takeScreenshot(BuildContext context) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    await _screenshotController
        .capture(
            pixelRatio: pixelRatio, delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath =
            await File('${directory.path}/Weekly summary.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareFiles([imagePath.path],
            text: 'My Crunch Carbon Weekly Summary!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Screenshot(
          controller: _screenshotController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '1230.23',
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
                  'Weekly Usage',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: BarChartSample3()),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              _takeScreenshot(context);
            },
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BarChartSample3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
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
        padding: const EdgeInsets.only(right: 20.0, left: 12),
        child: TheBarChart(),
      ),
    );
  }
}

class TheBarChart extends StatelessWidget {
  TheBarChart({
    Key? key,
  }) : super(key: key);

  final barRodData = BarChartRodData(
    y: 250,
    colors: [const Color(0xff147AD6)],
    width: 22,
    borderRadius: BorderRadius.circular(4),
  );

  final data = [250, 500, 740, 400, 550, 300, 420];

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: 1000,
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
                ),
              );
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            if (value == 480) {
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
            interval: 50,
            getTitles: (value) {
              switch (value.toInt()) {
                case 250:
                  return '250';
                case 500:
                  return '500';
                case 750:
                  return '750';
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
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'M';
                case 1:
                  return 'T';
                case 2:
                  return 'W';
                case 3:
                  return 'T';
                case 4:
                  return 'F';
                case 5:
                  return 'S';
                case 6:
                  return 'S';
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
                        e <= 480
                            ? Color(0xff7388A9).withOpacity(0.35)
                            : const Color(0xff147AD6)
                      ],
                    )
                  ],
                ))
            .toList(),
      ),
    );
  }
}
