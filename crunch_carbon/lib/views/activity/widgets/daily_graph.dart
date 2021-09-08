import 'package:crunch_carbon/models/session.dart';
import 'package:crunch_carbon/providers/ActivityProvider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyGraph extends StatefulWidget {
  const DailyGraph({
    Key? key,
  }) : super(key: key);

  @override
  State<DailyGraph> createState() => _DailyGraphState();
}

class _DailyGraphState extends State<DailyGraph> {
  List<Session> sessionList = [];
  bool loading = true;

  void _initData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var username = prefs.getString('username');
    sessionList = await context.read<ActivityProvider>().getSessions(token ?? 'undefined', username ?? 'undefined');
    setState(() {
      loading=false;
    });
  }

  List<FlSpot> getSpots(List<Session> sessions){
    List<FlSpot> theSpots = [];
    for(int i = 0; i<=DateTime.now().hour; i++){
      theSpots.add(FlSpot(i.toDouble(), sessions.where((e) => e.dateCreated.hour == i).map((e) => e.emissionQuantity).fold(0, (p, c) => p ?? 0 + c) ?? 0));
    }
    return theSpots;
  }

  double _totalCarbonUsed(){
    double sum = 0;
    DateTime today = DateTime.now();
    sessionList
        .where(
            (e) => (e.dateCreated.year == today.year)
                && (e.dateCreated.month == today.month)
                && (e.dateCreated.day == today.day)
    ).map((e) => e.emissionQuantity).forEach((double e){sum += e;});
    return sum;
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            _totalCarbonUsed().toString(),
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
        Expanded(
          child: LineChartSample2(
            spots: getSpots(sessionList),
          ),
        ),
      ],
    );
  }
}

class LineChartSample2 extends StatelessWidget {
  final bool showAvg;
  final double interval = 100;
  final double maxX = DateTime.now().hour.toDouble();
  final double maxY = 500;
  String getTiles(value) {
    switch (value.toInt()) {
      case 100:
        return '100';
      case 300:
        return '300';
      case 500:
        return '500';
    }
    return '';
  }
  final List<FlSpot> spots;

  final List<Color> gradientColors = [
    const Color(0xff147AD6),
    Colors.transparent,
  ];

  final List<Color> lineColor = [
    const Color(0xff147AD6),
    const Color(0xff147AD6),
  ];


  LineChartSample2({this.showAvg = false, required this.spots});

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
          interval: interval,
          getTitles: getTiles,
          reservedSize: 28,
          margin: 20,
        ),
      ),
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: maxY,
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
