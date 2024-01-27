import 'package:booktalk_app/widget/header.dart';
import 'package:flutter/material.dart';
    
class EspressioniResponsive extends StatefulWidget {
  final String value;

  const EspressioniResponsive({required this.value});

  @override
  _EspressioniResponsiveState createState() => _EspressioniResponsiveState();
}

class _EspressioniResponsiveState extends State<EspressioniResponsive> {
  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    //var stepSoluzioni = List.generate(10);

    return SafeArea(
      left: true,
      right: true,
      bottom: false,
      top: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
          // ----- HEADER -----
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Header(
                iconProfile: Image.asset('assets/person-icon.png'), 
                text: "Soluzione",
                isHomePage: false,
                isProfilo: false,
              ),
            ),
            backgroundColor: Colors.white,
            body: ListView.builder(
              itemCount: 20,              
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) { 
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("step ${index+1}",
                            style: TextStyle(fontSize: 10)),
                        ), 
                      ),
                      
                      SizedBox(height: 10,),

                      Text("Soluzione ${index +1}",
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.white,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10,),

                      Text("Descrizione ${index +1}",
                        textAlign: TextAlign.center, 
                        style: TextStyle(fontSize: 14),),

                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(left: mediaQueryData.size.width*0.1, right: mediaQueryData.size.width*0.1),
                            child: Container(
                              height: 1,
                              color: Colors.grey, // Colore della linea grigia
                            ),
                          ),
                        ),
                      ),                      
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}