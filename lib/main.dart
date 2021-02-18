import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightGreen,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Information livre'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Livre {
  final String auteur;
  final String titre;

  Livre({this.auteur, this.titre});

  factory Livre.fromJson(Map<String, dynamic> json) {
    return Livre(
      auteur: json['auteur'],
      titre: json['titre'],
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {

  final myController = TextEditingController();
  Future<Livre> _futureLivre;

  @override
  void initState() {
    super.initState();
    // _futureLivre = fetchLivre();
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
  Future<Livre> fetchLivre() async {
    final response =(myController.text != '' )?

    await http.get('https://module5.etienne-vaytilingom.re/livres/' + myController.text):await http.get('https://module5.etienne-vaytilingom.re/livres/3');

    if (response.statusCode == 200) {
      return Livre.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {setState(() {
          _futureLivre = fetchLivre();
        });},
        tooltip: 'Increment',
        child: Icon(Icons.send),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder<Livre>(future: _futureLivre,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: myController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Id Livre',
                        ),
                      ),
                      Text(snapshot.data.auteur,
                        style: Theme.of(context).textTheme.headline4),
                      Text(snapshot.data.titre,
                          style: Theme.of(context).textTheme.headline4),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              }
              return TextField(
                controller: myController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Id Livre',
                ),
              );
            }
            ),

        ),
      );
       // This trailing comma makes auto-formatting nicer for build methods
  }
}
