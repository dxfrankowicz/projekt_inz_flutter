import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:projekt_inz/model/Employee.dart';
import 'package:projekt_inz/file_utils.dart';
import 'package:projekt_inz/sqlite_db.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projekt inz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Projekt inz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _time;
  String _response;
  FileUtils _fileStorageTest;
  var _startTime;
  var _endTime;

  void startTimer() {
    setState(() {
      _response = "...";
    });
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  void stopTimer() {
    _endTime = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _time = _endTime - _startTime;
    });
  }

  @override
  void initState() {
    super.initState();
    DBProvider.db.database;
    _fileStorageTest = new FileUtils();
    _fileStorageTest.writeFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Powered by FLUTTER',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            RaisedButton(
                child: new Text(
                    "Pobierz dane z Internetu i wyświetl JSON".toUpperCase(),
                    textAlign: TextAlign.center),
                onPressed: fetchDataFromApi),
            RaisedButton(
                child: new Text(
                    "Połącz z bazą danych SQLite i wyświetl rekordy"
                        .toUpperCase(),
                    textAlign: TextAlign.center),
                onPressed: getDataFromDatabase),
            RaisedButton(
                child: new Text(
                    "Uzyskaj dostęp do pliku systemowego".toUpperCase(),
                    textAlign: TextAlign.center),
                onPressed: getFileFromAppDirectory),
            SizedBox(height: 10.0),
            Center(child: Text("Czas wykonania operacji".toUpperCase())),
            Center(
              child: Text(
                _time?.toString() ?? "--:--",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_response ?? "..."),
            )
          ],
        ));
  }

  void fetchDataFromApi() {
    startTimer();
    http.get('http://dummy.restapiexample.com/api/v1/employees').then((rsp) {
      setState(() {
        List jsonResponse = convert.jsonDecode(rsp.body);
        jsonResponse.forEach((e) {
          _response += "\n ${Employee.fromJson(e)}";
        });
        stopTimer();
      });
    }).whenComplete(() {
      stopTimer();
    }).catchError((e) {
      _response = "Wystąpił błąd, spróbuj jeszcze raz. \n${e.toString()}";
    });
  }

  Future getDataFromDatabase() async {
    startTimer();
    var x = await DBProvider.db.getAllUsers();
    setState(() {
      x.forEach((e) {
        _response += "\n ${e.toString()}";
      });
    });
    stopTimer();
  }

  Future getFileFromAppDirectory() async {
    startTimer();
    _fileStorageTest.readFile().then((v) {
      setState(() {
        _response = v.toString();
      });
    }).whenComplete(() {
      stopTimer();
    }).catchError((e) {
      _response = "Wystąpił błąd, spróbuj jeszcze raz. \n${e.toString()}";
    });
  }
}
