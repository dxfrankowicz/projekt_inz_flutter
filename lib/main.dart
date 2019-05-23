import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projekt_inz/animation_utils.dart';
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
      title: 'Projekt inżynierski',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Projekt inżynierski'),
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

  bool animationTest = false;

  void startTimer() {
    setState(() {
      _startTime = DateTime.now().millisecondsSinceEpoch;
      _response = "...";
    });
  }

//  int index = 0;
//  List durations = new List();

  void stopTimer() {

    setState(() {
      _endTime = DateTime.now().millisecondsSinceEpoch;
      animationTest = false;
      _time = _endTime - _startTime;
//      durations.add(_time);

//      index++;
//      print(index.toString());
//      if(index==100) print(durations.toString());

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
            createButton(
                "Pobierz dane z Internetu i wyświetl JSON", fetchDataFromApi),
            createButton("Połącz z bazą danych SQLite i wyświetl rekordy",
                getDataFromDatabase),
            createButton(
                "Uzyskaj dostęp do pliku systemowego", getFileFromAppDirectory),
            createButton("Wykonaj test animacji", executeAnimationTest),
            SizedBox(height: 10.0),
            Center(child: Text("Czas wykonania operacji".toUpperCase())),
            Center(
              child: Text(
                _time?.toString() ?? "--:--",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
            animationTest
                ? LogoAnimationTest(notifyParent: stopTimer)
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_response ?? "..."),
                  )
          ],
        ));
  }

  Widget createButton(String text, VoidCallback function) {
    return RaisedButton(
        child: new Text(text.toUpperCase(), textAlign: TextAlign.center),
        onPressed: function);
  }

  void executeAnimationTest() {
    setState(() {
      startTimer();
      animationTest = true;
    });
  }

  String getErrorMsg(e){
    return "Wystąpił błąd, spróbuj jeszcze raz. \n${e.toString()}";
  }

  void fetchDataFromApi() {
    startTimer();
    http.get('http://dummy.restapiexample.com/api/v1/employees').then((rsp) {
      setState(() {
        List jsonResponse = convert.jsonDecode(rsp.body);
        jsonResponse.forEach((e) {
          _response += "\n ${Employee.fromJson(e)}";
        });
      });
    }).whenComplete(() {
      stopTimer();
    }).catchError((e) {
      _response = getErrorMsg(e);
    });
  }

  Future getDataFromDatabase() async {
    startTimer();
    var x = await DBProvider.db.getAllUsers();
      Future.forEach(x, (e)=>addToResponse(e)).then((v){
        setState(() {
          stopTimer();
        });
      });
  }

  Future addToResponse(e) async{
    _response += "\n ${e.toString()}";
    print(e.toString());
  }

  void getFileFromAppDirectory() {
    startTimer();
    _fileStorageTest.readFile().then((v) {
      setState(() {
        _response = v.toString();
      });
    }).whenComplete(() {
      stopTimer();
    }).catchError((e) {
      _response = getErrorMsg(e);
    });
  }
}
