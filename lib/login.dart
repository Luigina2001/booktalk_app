import 'package:flutter/material.dart';
import 'registrazione.dart';
import 'profilo.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ------ HEADER ------
      appBar: AppBar(
        leading: BackButton(color: Color(0xFF0099b5)), // freccia indietro
        title: Text('Login', style: TextStyle(color: Color(0xFF0099b5), fontWeight: FontWeight.bold,),),
        backgroundColor: Color(0xFFbee2ee),
        elevation: 0.1,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 180, right: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Image.asset('assets/person-icon.png', width: 150, height: 150),
            SizedBox(height: 20),


            // ------ EMAIL ------
            TextField(
              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
            ),
            SizedBox(height: 10),

            // ------ PASSWORD ------
            TextField(
              decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
              obscureText: true, // Per nascondere la password
            ),
            SizedBox(height: 10),

             // ------ Pulsante "Accedi" ------
            ElevatedButton(
              onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(200, 50)),
                backgroundColor: MaterialStateProperty.all(Color(0xFF0099b5)),
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16, fontWeight: FontWeight.bold,)),
              ),
              child: Text('Accedi'),
            ),

            // ------ "Registrati ora" ------
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegistrationPage(),
                  ));
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Non sei ancora registrato? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Registrati ora',
                        style: TextStyle(
                          color: Color(0xFF0099b5),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),

    );
  }
}