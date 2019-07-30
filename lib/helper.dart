import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class Helper {
  static final Helper _taskHelper = Helper._internal();

  factory Helper() {
    return _taskHelper;
  }

  Helper._internal();

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/tasks.json");
  }

  Future<String> readData() async {
    //  try {
    final file = await getFile();
    if (file.existsSync()) {
      return file.readAsString();
    } else {
      return null;
    }
  }

  Future<String> getlogo(idC) async {
    Firestore db = Firestore.instance;
    try {
      DocumentSnapshot snapLogo =
          await db.collection("logo").document("$idC").get();
      var dados = snapLogo.data;
      if (dados != null) {
        return dados["logo"].toString();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getofertas(idC) async {
    final String tagOfertas = 'ofertas-' + idC;
    Firestore db = Firestore.instance;
    try {
      QuerySnapshot snapOfertas =
          await db.collection("$tagOfertas").getDocuments();
      var dados = snapOfertas.documents;
      if (dados.length != 0) {
        return "logo";
      } else {
        return "";
      }
    } catch (e) {
      return null;
    }
  }  
}
