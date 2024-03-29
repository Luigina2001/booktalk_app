import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:booktalk_app/caricamentoResponsive.dart';
import 'package:booktalk_app/chatResponsive.dart';
import 'package:booktalk_app/getISBN.dart';
import 'package:booktalk_app/opera.dart';
//import 'package:booktalk_app/storage/libreriaDAO.dart';
import 'package:booktalk_app/storage/libro.dart';
import 'package:booktalk_app/widget/ErrorAlertPageISBN.dart';
import 'package:booktalk_app/widget/ExpandableFloatingActionButton.dart';
import 'package:booktalk_app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibreriaResponsive extends StatefulWidget {
  final bool is2;
  final bool is3;

  const LibreriaResponsive({Key? key, required this.is2, required this.is3})
      : super(key: key);

  @override
  _LibreriaResponsiveState createState() => _LibreriaResponsiveState();
}

class _LibreriaResponsiveState extends State<LibreriaResponsive> {
  //File ? _selectedImageAddLibro;
  //File ? _selectedImageOpera;
  late Future<List<Libro>> libreria;
  bool dataLoaded = false;
  int numLibri = 0;
  late int id;
  //LibreriaDao _libreriaDao = LibreriaDao('http://130.61.22.178:9000');

  @override
  void initState() {
    super.initState();
    const secondsToDelay = 3;
    Timer(Duration(seconds: secondsToDelay), () {
      loadUserData();
      //_reloadPageAfterDelay();
    });
  }

  Future<List<Libro>> getLibreriaFromPreferences(
      SharedPreferences preferences) async {
    String libreriaJson = preferences.getString('libreria') ?? '';
    List<Libro> libreria = [];

    if (libreriaJson.isNotEmpty) {
      List<dynamic> libreriaList = json.decode(libreriaJson);
      libreria =
          libreriaList.map((libroData) => Libro.fromJson(libroData)).toList();
      numLibri = libreria.length;
    }
    return libreria;
  }

  // Funzione per caricare i dati dell'utente dalle SharedPreferences
  Future<void> loadUserData() async {
    print("Loading user data...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences = await SharedPreferences.getInstance();
    //String utenteJson = _preferences.getString('utente') ?? '';

    libreria = getLibreriaFromPreferences(preferences);
    libreria.then((value) {
      dataLoaded = true;
      setState(() {});
    });
  }

  /*void _reloadPageAfterDelay() {
    const secondsToDelay = 5;
    Timer(Duration(seconds: secondsToDelay), () {
      loadUserData();
      setState(() {}); // Ricarica la pagina aggiornando la UI
    });
    }*/

  // Funzione per caricare i dati dell'utente dalle SharedPreferences
  /*Future<void> _loadUserData() async {
    print("Loading user data...");
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String utenteJson = _preferences.getString('utente') ?? '';
    if (utenteJson.isNotEmpty) {
      Map<String, dynamic> utenteMap = json.decode(utenteJson);
      id = utenteMap['ID'];
      print(id);
      /*libreria = _libreriaDao.getLibreriaUtente(id);
      libreria.then((value) {dataLoaded = true;
      numLibri = value.length;});*/
      
      setState(() {});
    }
  }*/

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.transparent,

      // HEADER
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isTabletOrizzontale(mediaQueryData)
            ? mediaQueryData.size.height * 0.1
            : mediaQueryData.size.height * 0.07),
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
              Image.asset(
                "assets/linea.png",
                width: 50,
              ),
              SizedBox(height: mediaQueryData.size.height * 0.013),
              Text(
                'Libreria',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              //SizedBox(height: 2),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            height: isTablet(mediaQueryData)
                ? mediaQueryData.size.height * 0.02
                : mediaQueryData.size.height * 0.02,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.is2)
                Image.asset(
                  "assets/2.jpeg",
                  height: 40,
                )
              else if (widget.is3)
                Image.asset(
                  "assets/funzionalità3.jpg",
                  height: 40,
                ),
              if (widget.is2 || widget.is3)
                SizedBox(
                  width: 20,
                ),
              Text(
                (widget.is2 || widget.is3) ? "Seleziona un libro" : "",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          SizedBox(
              height: (widget.is2 || widget.is3)
                  ? isTablet(mediaQueryData)
                      ? mediaQueryData.size.height * 0.02
                      : mediaQueryData.size.height * 0.02
                  : 0),

          // ----------- LISTA A GRIGLIA -----------
          Expanded(
            child: dataLoaded == false
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF0097b2)))
                : numLibri == 0
                    ? Text("Non sono presenti libri")
                    : CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: EdgeInsets.only(bottom: 60.0),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    isTabletOrizzontale(mediaQueryData)
                                        ? 5
                                        : isTabletVerticale(mediaQueryData)
                                            ? 4
                                            : 3,
                                crossAxisSpacing:
                                    isTabletOrizzontale(mediaQueryData)
                                        ? 23
                                        : 20,
                                mainAxisSpacing: 50,
                                childAspectRatio: 3 /
                                    (isTabletOrizzontale(mediaQueryData)
                                        ? 2
                                        : 3),
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return FutureBuilder<List<Libro>?>(
                                    future: libreria,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.data == null) {
                                        return Text('Libreria non trovata');
                                      } else {
                                        List<Libro> libri = snapshot.data!;
                                        if (libri.isNotEmpty) {
                                          if (libri[index].copertina != null) {
                                            Uint8List imageBytes =
                                                Uint8List.fromList(
                                                    libri[index].copertina!);
                                            return GestureDetector(
                                              onTap: () {
                                                if (widget.is2) {
                                                  getImageFromCameraOpera(
                                                      libri[index], context);
                                                } else if (widget.is3) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatResponsive(
                                                              libro:
                                                                  libri[index]),
                                                    ),
                                                  );
                                                } else {
                                                  _showDialog(
                                                      context,
                                                      libri[index],
                                                      imageBytes,
                                                      mediaQueryData);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  //border: Border.all(width: 1.0, color: Colors.grey),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child:
                                                      Image.memory(imageBytes),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Text(
                                                'COPERTINA non disponibile');
                                          }
                                        } else {
                                          return Text("");
                                        }
                                      }
                                    },
                                  );
                                },
                                childCount: numLibri,
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),

      // ----------- PUSANTE AGGIUNGI LIBRO -----------
      floatingActionButton: ExpandableFloatingActionButton(
        icon: Icons.add,
        label: 'Aggiungi Libro',
        scrollController: _scrollController,
        onPressed: () {
          _scrollController.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          getImageFromCameraISBN();
        },
      ),
    );
  }

  Future<File> loadSelectedImage(String imagePath) async {
    // Simulate an operation that could be blocking
    await Future.delayed(Duration(seconds: 2));
    // Execute the file creation operation on a separate thread
    return await File(imagePath);
  }

  Future<void> getImageFromCameraISBN() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          CaricamentoResponsive(text: "Ricerca dell'ISBN in corso..."),
    ));

    loadSelectedImage(image.path).then((File value) {
      // Ritarda la navigazione per evitare il blocco dell'interfaccia utente
      Future.delayed(Duration(seconds: 2), () {
        //Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GetIsbn(foto: value),
          ),
        );
      });
    }).catchError((error) {
      // Gestisce gli errori di caricamento dell'immagine
      Future.delayed(Duration(seconds: 2), () {
        //Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                ErrorAlertPageIsbn(text: "Errore nella ricerca dell'ISBN!"),
          ),
        );
      });
    });
  }

  Future load(final _selectedImage) async {
    Uint8List _imageBytes = await _selectedImage.readAsBytes();

    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setString('imageOpera', base64Encode(_imageBytes));
  }

  Future<void> getImageFromCameraOpera(
      Libro libro, BuildContext context) async {
    Future<XFile?> image = ImagePicker().pickImage(source: ImageSource.camera);

    image.then((value) {
      if (value == null) {
        return;
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                CaricamentoResponsive(text: "Caricamento in corso..."),
          ),
        );
        String imageString = base64Encode(File(value.path).readAsBytesSync());

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Opera(libro: libro, imageString: imageString),
          ),
        );
      }
    });
  }
  /*setState(() {
      _selectedImageOpera = File(image!.path);
    });*/
  /*
    loadSelectedImage(image.path).then((File value) {
    });*/
  /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CaricamentoResponsive(text: "Caricamento in corso..."),
      )
    );

    print("aaa");
    final _selectedImageOpera = await File(image.path);
    setState(() {
      
    });

    print("bbb");
    //Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Opera(selectedImageOpera: _selectedImageOpera, libro: libro),
      ),
    );*/

  /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CaricamentoResponsive(text: "Caricamento in corso..."),
      )
    );

    loadSelectedImage(image.path).then((File value) {
      // Ritarda la navigazione per evitare il blocco dell'interfaccia utente
      Future.delayed(Duration(seconds: 2), () {
        //Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OpereLetterarieResponsive(
              selectedImageOpera: value,
              libro: libro,
            ),
          ),
        );
      });
    }).catchError((error) {
      // Gestisce gli errori di caricamento dell'immagine
      Future.delayed(Duration(seconds: 2), () {
        //Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ErrorAlertPageIsbn(text: "Errore nella ricera dell'opera!"),
          ),
        );
      });
    });

    */

  void _showDialog(BuildContext context, Libro libro, Uint8List copertina,
      var mediaQueryData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(25.0),
              ),
              width: isTabletOrizzontale(mediaQueryData)
                  ? mediaQueryData.size.width * 0.5
                  : isTabletVerticale(mediaQueryData)
                      ? mediaQueryData.size.width * 0.6
                      : mediaQueryData.size.width * 0.65,
              height: isTabletOrizzontale(mediaQueryData)
                  ? mediaQueryData.size.height * 0.65
                  : mediaQueryData.size.height * 0.45,
              alignment: Alignment.center,
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Hero(
                    tag: "book_cover",
                    child: Padding(
                      padding: const EdgeInsets.all(
                          15), // Aggiunge spazio attorno all'immagine
                      child: Image.memory(
                        copertina,
                        width: 80,
                      ),
                    ),
                  ),

                  Text(
                    libro.titolo,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: mediaQueryData.size.height * 0.05),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: mediaQueryData.size.width * 0.1,
                      ),
                      Text(
                        "Autori: ",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        libro.autori,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: mediaQueryData.size.height * 0.03),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: mediaQueryData.size.width * 0.1,
                      ),
                      Text(
                        "Edizione: ",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        libro.edizione,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  //SizedBox(height: 25.0),

                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: IntrinsicWidth(
                        stepWidth: isTabletOrizzontale(mediaQueryData)
                            ? mediaQueryData.size.width * 0.5 + 30
                            : isTabletVerticale(mediaQueryData)
                                ? mediaQueryData.size.width * 0.6 + 35
                                : mediaQueryData.size.width * 0.65 + 35,

                        //stepWidth: isTablet(mediaQueryData) ? (mediaQueryData.size.width*0.5)+30 : (mediaQueryData.size.width*0.5)+35 ,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // seconda funzionalità
                                  getImageFromCameraOpera(libro, context);
                                },
                                child: Container(
                                  //width: (width*0.5)/2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(25)),
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey)),
                                  height: 50,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Image.asset("assets/2.jpeg"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // terza funzionalità
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatResponsive(libro: libro),
                                    ),
                                  );
                                },
                                child: Container(
                                  //width: (width*0.5)/2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(25),
                                    ),
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey),
                                  ),
                                  height: 50,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Image.asset(
                                          "assets/funzionalità3.jpg"),
                                    ),
                                  ),
                                ),
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
          ),
        );
      },
    );
  }
}
