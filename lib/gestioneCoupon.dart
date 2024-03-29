import 'dart:convert';
import 'package:booktalk_app/business_logic/gestioneAutorizzazioni.dart';
import 'package:booktalk_app/business_logic/gestioneAutorizzazioniService.dart';
import 'package:booktalk_app/caricamentoResponsive.dart';
import 'package:booktalk_app/storage/libro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;

import 'package:shared_preferences/shared_preferences.dart';

void mostraErrore(BuildContext context, String messaggio) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red, // Colore dell'icona
          ),
          SizedBox(width: 8), // Spazio tra l'icona e il testo
          Expanded(
            child: Text(
              messaggio,
              style: TextStyle(
                color: Colors.red, // Colore del testo
                fontWeight: FontWeight.bold, // Grassetto
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white, // Colore di sfondo
      duration: Duration(seconds: 3), // Durata del messaggio
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  void modificaOK(BuildContext context, String messaggio) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.verified,
            color: Colors.green, // Colore dell'icona
          ),
          SizedBox(width: 8), // Spazio tra l'icona e il testo
          Expanded(
            child: Text(
              messaggio,
              style: TextStyle(
                color: Colors.green, // Colore del testo
                fontWeight: FontWeight.bold, // Grassetto
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white, // Colore di sfondo
      duration: Duration(seconds: 3), // Durata del messaggio
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> checkAutorizzazioneInLibreria(String isbn) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String libreriaJson = _preferences.getString('libreria') ?? '';
    List<Libro> libreria = [];

    if (libreriaJson.isNotEmpty) {
      List<dynamic> libreriaList = json.decode(libreriaJson);
      libreria = libreriaList.map((libroData) => Libro.fromJson(libroData)).toList();
    }

    for (Libro l in libreria){
      if (l.isbn == isbn)
        return false;
    }
    return true;
  }


Future<String> verificaCoupon(String isbn, String coupon, BuildContext context) async {
  WidgetsFlutterBinding.ensureInitialized();

  int idUtente = 0;
  String s = "OK";
  

  //Prendere i parametri isbn e coupon da quelli che ha inserito l'utente
  //String isbn = '8806134965';
  //String coupon = 'A45DF3';
  
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => CaricamentoResponsive(text: "Aggiornamento dei dati in corso...")
    ),
  );

  bool checkAutorizzazione = await checkAutorizzazioneInLibreria(isbn);
  if (checkAutorizzazione){
    
    final url = 'http://130.61.22.178:9000/verificaCoupon';

    final response = await http.post(Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'isbn': isbn, 'coupon': coupon})
      );
    
    if (response.statusCode == 200) {
        
      final data = jsonDecode(response.body);

      if (data['result']) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String utenteJson = preferences.getString('utente') ?? '';
        if (utenteJson.isNotEmpty) {
          Map<String, dynamic> utenteMap = json.decode(utenteJson);
          idUtente = int.parse(utenteMap['ID'].toString());
          GestioneAutorizzazioniService service = GestioneAutorizzazioni();
          await service.addAutorizzazione(isbn, idUtente, preferences);

          print('Il libro è supportato e il codice coupon è valido.');
          return 'Il libro è supportato e il codice coupon è valido.';
                    
        } else {
          s = "ERRORE: impossibile inoltrare la richiesta!";
          print("ERRORE: utente non trovato");
          return s;   
        }

      } else {
        s = "Libro attualmente non supportato o codice coupon non valido.";
        print('Libro attualmente non supportato o codice coupon non valido.');
        return s;
      }
    } else {
      s = "ERRORE: impossibile inoltrare la richiesta!";
      print("ERRORE: impossibile inoltrare la richiesta!");
      return s;
    }
  } else {
    s = "Il libro è già presente nella tua libreria!";
    print("libro già presente");
    return s;
  }
}

