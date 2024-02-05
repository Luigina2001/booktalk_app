import 'package:booktalk_app/homepageResponsive.dart';
import 'package:booktalk_app/main.dart';
import 'package:booktalk_app/profiloResponsive.dart';
import 'package:booktalk_app/widget/AllertConferma.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
    
class Header extends StatefulWidget {
  const Header({Key? key, 
  required this.text, 
  required this.iconProfile,
  required this.isHomePage,
  required this.isProfilo}) : super(key: key);

  /*
    text - Corrisponde al testo da visuallizzare nell'Header
    iconProfile - Corrisponde all'immage del profilo
    isHomePage - settato a true solo nella homepage, per non visualizzare il pulsante indietro
    isProfilo - settato a true solo nel profilo, per non visualizzare il pulsante profilo ma il logout

    in tutti gli alti casi, entrambi sono true
  */

  final String text;
  final Image iconProfile;  // passsare la foto del profilo dell'utente
  final bool isHomePage, isProfilo;


  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  
  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    
    return AppBar(
      forceMaterialTransparency: true,
      // Pulsante Indietro
      leading:  widget.isHomePage 
        ? null 
        : Transform.scale(
            scale: 0.8,
            child:IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0097b2),), // Icona personalizzata
              onPressed: () {
                if(Navigator.of(context).canPop()){ // controlla che c'è la pagina indietro
                   Navigator.of(context).pop(); // Torna indietro alla schermata precedente
                }else{
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomepageResponsitive(),
                    ),
                  );
                }
              },
              //iconSize: 25,
              // iconSize: iconSize(mediaQueryData.size.width, mediaQueryData.size.height, 0.005),
              
            ),
          ),
      // Testo
      
      automaticallyImplyLeading: !widget.isHomePage, // toglie lo spazio occupoato dall'elemento
      title: Text(
        widget.text,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
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

      backgroundColor: Color.fromARGB(0, 255, 255, 255),
      
      // Pulsate Logout/Profilo
      actions: <Widget>[
        Transform.scale(
          scale: 0.6,
          child: Padding(
            padding: EdgeInsets.only(right: 0),
            child:
              widget.isProfilo
              ? 
                // ----- ALLERT CONFERMA LOGOUT -----
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: AllertConferma(),
                    ),
                  ),
                  icon: Image.asset("assets/logout.png"),
                  iconSize: 0,
                )
              : IconButton(
                icon: widget.iconProfile,
                iconSize: 2,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                    builder: (context) => ProfiloResponsitive(),
                    ),
                  ); 
                },
              ),
          ),
        ),
      ],
      elevation: 0,
    );
  }
}