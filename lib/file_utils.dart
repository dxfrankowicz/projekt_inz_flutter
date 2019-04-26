import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.txt');
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return "Ścieżka \n${file.path} \n\nZawartość pliku \n$contents";
    } catch (e) {
      return "Wystąpił błąd, spróbuj jeszcze raz. \n${e.toString()}";
    }
  }

  Future<File> writeFile() async {
    final file = await _localFile;
    return file.writeAsString('Testowy dokument tekstowy');
  }
}
