import 'dart:convert';
import 'dart:io';
import 'package:booktalk_app/espressioniResponsive.dart';
import 'package:booktalk_app/widget/ErrorAlertPage.dart';
import 'package:booktalk_app/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future, runZonedGuarded;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

Future<List<String>> risolviEspressione(String value) async {
  WidgetsFlutterBinding.ensureInitialized();

  List<String> step = [];
  String sourceId = '';

  try {
    final apiUrl =
        Uri.parse('http://130.61.22.178:9000/wolframalpha/show_step');

    final response = await http.post(apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': value}));

    
    print(response.headers);

    // Gestisci la risposta
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      String testo = data['step'];

      print(testo);
      int indiceInizio = 0;

      if (testo.isEmpty) {
        return step;
      } else {
        print(testo);
        //testo = testo.replaceAll('|', '');
        //print(testo);
        for (int i = 0; i < testo.length; i++) {
          if (testo[i] == '\n') {
            step.add(testo.substring(indiceInizio, i));
            indiceInizio = i + 1; // Ignora il carattere '\n' stesso
          }
        }
        // Aggiungi l'ultima riga
        step.add(testo.substring(indiceInizio));
        // Stampa le righe
        print(step);
      }
    } else {
      print('Errore nella richiesta API: ${response.statusCode}');
    }
  } catch (e) {
    print('Errore: $e');
  }

  return step;
}

class GetExpression extends StatefulWidget {
  final String exp;

  const GetExpression({Key? key, required this.exp}) : super(key: key);

  @override
  _GetExpression createState() => _GetExpression();
}

class _GetExpression extends State<GetExpression> {
  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);

    return FutureBuilder(
        // initialize flutterfire:
        future: risolviEspressione(widget.exp),
        builder: (context, list) {
          // check for errors
          if (list.hasError) {
            return Text("Errore. Ti invitiamo a riprovare");
            //AGGIUNGERE BOX CON MESSAGGIO DI ERRORE
          } else if (list.connectionState ==
              ConnectionState.done) {
            List<String> data = list.data as List<String>;

            if (data.isEmpty) {
              return MaterialApp(
                title: 'Errore Equazione Matematica',
                home: ErrorAlertPage(
                  text: 'Equazione non valida o soluzione non appartenente all\'insieme dei numeri reali. Riprovare!',
                  ),
              );
            } else {
              return EspressioniResponsive(step: data);
            }
          } else {
            return SafeArea(
              left: true,
              right: true,
              bottom: false,
              top: true,
              child: Scaffold(
                // ----- HEADER -----
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Header(
                    iconProfile: Image.asset('assets/person-icon.png'),
                    text: "",
                    isHomePage: false,
                    isProfilo: false,
                  ),
                ),
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: mediaQueryData.size.height * 0.15,
                      ),
                      Text(
                        "Calcolo dell'espressione inserita in corso",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: mediaQueryData.size.height * 0.15,
                      ),
                      CircularProgressIndicator(
                        color: Color(0xFF0097b2),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}