import 'dart:convert';

import 'package:booktalk_app/business_logic/gestioneAutorizzazioniService.dart';
import 'package:booktalk_app/storage/autorizzazione.dart';
import 'package:booktalk_app/storage/autorizzazioneDAO.dart';
import 'package:booktalk_app/storage/libreriaDAO.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GestioneAutorizzazioni implements GestioneAutorizzazioniService{

  AutorizzazioneDao dao = AutorizzazioneDao('http://130.61.22.178:9000');
  LibreriaDao daoLib = LibreriaDao('http://130.61.22.178:9000');


  @override
  Future<Map<String, dynamic>> addAutorizzazione(String isbn, int id, SharedPreferences preferences) async {

    try{

      DateTime date = DateTime.now();
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      final String formattedDate = dateFormatter.format(date);

      final DateFormat dateFormatterData = DateFormat('yyyy-MM-dd');
      DateTime dataScadenza = date.add(Duration(days: 365));
      final String formattedScadenza = dateFormatterData.format(dataScadenza);

      //print(formattedScadenza);

      Autorizzazione toInsert = Autorizzazione(
        tempoUtilizzato: formattedDate, 
        dataScadenza: formattedScadenza, 
        utente: id, 
        libro: isbn);
      
        try {
          await dao.insertAutorizzazione(toInsert);
          await daoLib.updateLibreria(id);
          await preferences.remove('libreria');
          List<Map<String, dynamic>> libreriaJson = await daoLib.getLibreriaUtenteJson(id);
          await preferences.setString('libreria', json.encode(libreriaJson));
          return {'success': 'Inserimento avvenuto con successo.'};
        }catch(e){
          return {'error': 'Aggiunta libro non riuscita.'};
        }

    }catch(e){
      print("Errore inserimento autorizzazione in business_logic/gestioneAutorizzazioni.dart: $e");
      return {'error': 'Errore durante la modifica.'};
    }

  }

  /*
  @override
  Future<bool> isAutorizzazioneScaduta(String isbn, int id) async {
    Autorizzazione? autorizzazione = await dao.getAutorizzazioneById(isbn, id);
    if (autorizzazione != null){
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      String dataScadenza = autorizzazione.dataScadenza;
      DateTime scadenza = dateFormatter.parse(dataScadenza);
      DateTime oggi = DateTime.now();
      
      // Verifica se la data di scadenza è successiva alla data odierna
      if (scadenza.isAfter(oggi)) {
        return false; // L'autorizzazione non è scaduta
      } else {
        return true; // L'autorizzazione è scaduta
      }
    }
    return false;
  }*/
}