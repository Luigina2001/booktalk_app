import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'utils.dart';
    
class Statistiche extends StatefulWidget {
  const Statistiche({Key? key}) : super(key: key);

  @override
  _StatisticheState createState() => _StatisticheState();
}

class _StatisticheState extends State<Statistiche> {
  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(mediaQueryData.size.height * 0.07),

        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF0097b2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: mediaQueryData.size.height * 0.006),
              Image.asset("assets/linea.png", width: mediaQueryData.size.width * 0.1,),
              SizedBox(height: mediaQueryData.size.height * 0.015),
              Text(
                'Statistiche',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: size(mediaQueryData.size.width, mediaQueryData.size.height, 16),
                ),
              ),
              //SizedBox(height: 2),
            ],
          ),
        ),
      ),

      //backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: 10,),
          Text(
                "Libro più utilizzato", 
                style: TextStyle(fontSize: size(mediaQueryData.size.width, mediaQueryData.size.height, 18), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Titolo libro", 
                style: TextStyle(fontSize: size(mediaQueryData.size.width, mediaQueryData.size.height, 14), fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: mediaQueryData.size.width * 0.1,),
              Image.asset(
                "assets/copertina.jpg",
                width: getMinor(mediaQueryData.size.width, mediaQueryData.size.height) > 600 ? 100 : 60,
              ),
            ],
          ),
          SizedBox(height: 80,), 
          Text(
            "Percentuale di utilizzo delle funzionalità", 
            style: TextStyle(fontSize: size(mediaQueryData.size.width, mediaQueryData.size.height, 18), fontWeight: FontWeight.bold,), 
            textAlign: TextAlign.center,
          ), 
          
          SizedBox(height: 20,), 
          
          Container(
          width: 300,
          height: 300,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(
              show: false,
            ),
            centerSpaceRadius: 5,
            sections: _pieChartData(
              30, // funzionalità 1
              18, // funzionalità 2
              62, // funzionalità 3
            ),
            ),
            swapAnimationDuration: Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.linear, // Optional
          ),
          ),

          SizedBox(height: 20,),
        ],
      ),
    );
  }
}


List<PieChartSectionData> _pieChartData(double funz1, double funz2, double funz3, ) {
  return [
    PieChartSectionData(
      color: Color.fromARGB(160, 240, 189, 94),
      value: funz1,
      title: '${funz1}%',
      radius: 100,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff),
        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
      ),
      badgeWidget: Container(
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(.5),
              offset: const Offset(3, 3),
              blurRadius: 3,
            ),
          ],
        ),
        padding: EdgeInsets.all(5),
        child: Center(
          child: Image.asset('assets/1.png', width: 40,),
        ),
      ),
      badgePositionPercentageOffset: 1.1,
    ),

    PieChartSectionData(
      color: Color.fromARGB(160, 5, 168, 186),
      value: funz2,
      title: '${funz2}%',
      radius: 100,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff),
        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
      ),
      badgeWidget: Container(
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(.5),
              offset: const Offset(3, 3),
              blurRadius: 3,
            ),
          ],
        ),
        padding: EdgeInsets.all(5),
        child: Center(
          child: Image.asset('assets/2.jpeg', width: 40,),
        ),
      ),
      badgePositionPercentageOffset: 1.1,
    ),

    PieChartSectionData(
      color: Color.fromARGB(160, 255, 60, 42),
      value: funz3,
      title: '${funz3}%',
      radius: 100,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff),
        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
      ),
      badgeWidget: Container(
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(.5),
              offset: const Offset(3, 3),
              blurRadius: 3,
            ),
          ],
        ),
        padding: EdgeInsets.all(5),
        child: Center(
          child: Image.asset('assets/funzionalità3.jpg', width: 42,),
        ),
      ),
      badgePositionPercentageOffset: 1.1,
    ),
  ];
}