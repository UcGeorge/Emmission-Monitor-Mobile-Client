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
    sessionList = (await context.read<ActivityProvider>().getSessions(token ?? 'undefined', username ?? 'undefined')).where((e) => isToday(e)).toList();
    Future.delayed(Duration(milliseconds: 500), (){
      setState(() {
        loading = false;
      });
    });
    // print('There were ${sessionList.length} sessions today');
  }

  List<FlSpot> dailySpots(List<Session> sessions){
    List<FlSpot> theSpots = [];
    for(int i = 0; i<=DateTime.now().hour; i++){
      double totalEmission = 0;

      sessions
          .where((e) => e.dateCreated.hour == i)
          .map((e) => e.emissionQuantity)
          .forEach((num e){totalEmission += e.toDouble();});

      theSpots.add(FlSpot(i.toDouble(), totalEmission));
    }
    // print('Spots: \n${theSpots}');
    return theSpots;
  }

  double _totalCarbonUsed(){
    double sum = 0;
    sessionList.where((e) => isToday(e)).map((e) => e.emissionQuantity).forEach((num e){sum += e.toDouble();});
    return sum;
  }

  bool isToday(Session e){
    DateTime today = DateTime.now();
    return (e.dateCreated.year == today.year)
        && (e.dateCreated.month == today.month)
        && (e.dateCreated.day == today.day);
  }

  double maxY(){
    List<double> yS = [];
    for(int i = 0; i<=DateTime.now().hour; i++){
      double totalEmission = 0;

      sessionList
          .where((e) => e.dateCreated.hour == i)
          .map((e) => e.emissionQuantity)
          .forEach((num e){totalEmission += e.toDouble();});

      yS.add(totalEmission);
    }
    yS.sort();
    double maxSpot = yS.last;
    return maxSpot >= 500 ? maxSpot : 500;
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
            _totalCarbonUsed().toStringAsFixed(2),
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
            spots: dailySpots(loading ? [] : sessionList),
            maxY: maxY(),
          ),
        ),
      ],
    );
  }
}

class LineChartSample2 extends StatelessWidget {
  final bool showAvg;
  final double maxX = DateTime.now().hour.toDouble();
  final double maxY;
  final double interval;
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
  final List<FlSpot> spots;

  final List<Color> gradientColors = [
    const Color(0xff147AD6),
    Colors.transparent,
  ];

  final List<Color> lineColor = [
    const Color(0xff147AD6),
    const Color(0xff147AD6),
  ];


  LineChartSample2({this.showAvg = false, required this.spots, required this.maxY}): interval = (5/100)*maxY;

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
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.transparent,
            fontWeight: FontWeight.bold,
            fontSize: 1,
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
