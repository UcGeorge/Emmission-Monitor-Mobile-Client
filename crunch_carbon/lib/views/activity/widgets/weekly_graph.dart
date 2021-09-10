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
    sessionList = (await context.read<ActivityProvider>().getSessions(token ?? 'undefined', username ?? 'undefined')).where((e) => isThisWeek(e)).toList();
    Future.delayed(Duration(milliseconds: 500), (){
      setState(() {
        loading = false;
      });
    });
    // print('There were ${sessionList.length} sessions this week');
  }

  bool isThisWeek(Session e){
    DateTime today = DateTime.now();
    DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday));
    DateTime lastDayOfWeek = today.add(Duration(days: DateTime.daysPerWeek - today.weekday));
    return firstDayOfWeek.isBefore(e.dateCreated) && lastDayOfWeek.isAfter(e.dateCreated);
  }

  List<double> weeklySpots(List<Session> sessions){
    List<double> theSpots = [];

    for(int i = 1; i<=DateTime.daysPerWeek; i++){
      double totalEmission = 0;

      sessions
          .where((e) => e.dateCreated.weekday == i)
          .map((e) => e.emissionQuantity)
          .forEach((num e){totalEmission += e.toDouble();});

      theSpots.add(totalEmission);
    }
    // print('Spots: \n${theSpots}');
    return theSpots;
  }

  double maxY(){
    List<double> yS = [];
    for(int i = 0; i<=DateTime.now().hour; i++){
      double totalEmission = 0;

      sessionList
          .where((e) => e.dateCreated.weekday == i)
          .map((e) => e.emissionQuantity)
          .forEach((num e){totalEmission += e.toDouble();});

      yS.add(totalEmission);
    }
    yS.sort();
    double maxSpot = yS.last;
    return maxSpot >= 500 ? maxSpot : 500;
  }

  double _totalCarbonUsed(){
    double sum = 0;
    sessionList.where((e) => isThisWeek(e)).map((e) => e.emissionQuantity).forEach((num e){sum += e.toDouble();});
    return sum;
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
                  _totalCarbonUsed().toStringAsFixed(2),
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
              Expanded(
                child: BarChartSample3(
                  data: weeklySpots(loading ? [] : sessionList),
                  maxY: maxY(),
                ),
              ),
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

class BarChartSample3 extends StatelessWidget {

  final List<double> data;
  final double maxY;
  final double interval;
  final barRodData = BarChartRodData(
    y: 250,
    colors: [const Color(0xff147AD6)],
    width: 22,
    borderRadius: BorderRadius.circular(4),
  );
  String getTiles(value) {
    if(double.parse(value.toString()).toStringAsFixed(0) == ((30/100)*maxY).toStringAsFixed(0)
        || double.parse(value.toString()).toStringAsFixed(0) == ((60/100)*maxY).toStringAsFixed(0)
        || double.parse(value.toString()).toStringAsFixed(0) == ((90/100)*maxY).toStringAsFixed(0))
    {
      // print(value);
      return value.toStringAsFixed(0);
    }
    return '';
  }

  BarChartSample3({required this.data, required this.maxY}) : interval = (5/100)*maxY;

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

  Widget TheBarChart(){
    int index = 0;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: maxY,
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
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) {
            if (double.parse(value.toString()).toStringAsFixed(0) == ((50/100)*maxY).toStringAsFixed(0)) {
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
            interval: interval,
            getTitles: getTiles,
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
              colors: [(e <= (50/100)*maxY) ? Color(0xff7388A9).withOpacity(0.35) : const Color(0xff147AD6)],
            )
          ],
        ))
            .toList(),
      ),
    );
  }
}
