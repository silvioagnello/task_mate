import 'dart:io';

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
    // return file.existsSync() ? file : null;
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
}
