import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:task_mate/drawer.dart';
import 'package:task_mate/helper.dart';
import 'package:task_mate/tasks.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> _categories = [
    Category("0", "MERCADO", Icons.local_grocery_store, Colors.orange[100]),
    Category("1", "FARMÁCIA", Icons.local_pharmacy, Colors.pink[100]),
    Category("2", "CONSTRUÇÃO", Icons.build, Colors.green[100]),
    Category("3", "TAREFAS", Icons.style, Colors.blueAccent[100]),
    Category("4", "AUTOMÓVEL", Icons.directions_car, Colors.blue[400]),
    Category("5", "ROUPAS", Icons.card_giftcard, Colors.red[200]),
    Category("6", "OUTROS", Icons.dashboard, Colors.brown[200]),
  ];

  List _toDoList3 = [];
  String qtPendCateg = '';
  int qtPend0 = 0;
  int qtPend1 = 0;
  int qtPend2 = 0;
  int qtPend3 = 0;
  int qtPend4 = 0;
  int qtPend5 = 0;
  int qtPend6 = 0;

  Helper helper = new Helper();

  @override
  void initState() {
    super.initState();

    helper.readData().then((data) {
      if (data != null) {
        setState(() {
          _toDoList3 = json.decode(data);

          _toDoList3.removeWhere((d) => d["ok"] == true);
          qtPend0 = _toDoList3.where((c) => c["idCateg"] == "0").length;
          qtPend1 = _toDoList3.where((c) => c["idCateg"] == "1").length;
          qtPend2 = _toDoList3.where((c) => c["idCateg"] == "2").length;
          qtPend3 = _toDoList3.where((c) => c["idCateg"] == "3").length;
          qtPend4 = _toDoList3.where((c) => c["idCateg"] == "4").length;
          qtPend5 = _toDoList3.where((c) => c["idCateg"] == "5").length;
          qtPend6 = _toDoList3.where((c) => c["idCateg"] == "6").length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController();
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 55.0),
          child: Text("LISTAS",
              style: TextStyle(fontSize: 30.0, fontFamily: "LibreBaskerville")),
        ),
      ),
      body: buildBody(_pageController),
      drawer: CustomDrawer(_pageController),
    );
  }

  buildBody(pc) {
    return PageView(
      controller: pc,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
            color: Colors.blue[100],
            child: ListView.builder(
                itemCount: _categories.length, itemBuilder: _categoryCards)),
        Container(color: Colors.yellow),
        Container(color: Colors.brown)
      ],
    );
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context, idx) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TasksPage(
                colorCateg: _categories[idx].color,
                idCateg: _categories[idx].idCateg.toString())));

    if (result != null) {
      switch (idx) {
        case 0:
          qtPend0 = int.parse(result);
          break;
        case 1:
          qtPend1 = int.parse(result);
          break;
        case 2:
          qtPend2 = int.parse(result);
          break;
        case 3:
          qtPend3 = int.parse(result);
          break;
        case 4:
          qtPend4 = int.parse(result);
          break;
        case 5:
          qtPend5 = int.parse(result);
          break;
        case 6:
          qtPend6 = int.parse(result);
          break;
      }
    }
  }

  Widget _categoryCards(context, idx) {
    String qtPendCateg;
    switch (_categories[idx].idCateg) {
      case "0":
        qtPendCateg = qtPend0.toString();
        break;
      case "1":
        qtPendCateg = qtPend1.toString();
        break;
      case "2":
        qtPendCateg = qtPend2.toString();
        break;
      case "3":
        qtPendCateg = qtPend3.toString();
        break;
      case "4":
        qtPendCateg = qtPend4.toString();
        break;
      case "5":
        qtPendCateg = qtPend5.toString();
        break;
      case "6":
        qtPendCateg = qtPend6.toString();
        break;
      default:
        qtPendCateg = '';
    }

    return GestureDetector(
      onTap: () {
        _awaitReturnValueFromSecondScreen(context, idx);
      },
      child: Padding(
        padding: const EdgeInsets.all(
            0.0), //only(top: 10.0, left: 20.0, right: 20.0, bottom: 0.0),
        child: Card(
          margin:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 2.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 5,
                bottom: 5,
                child: (int.parse(qtPendCateg) == 0)
                    ? Text("")
                    : Text(
                        "Pendências: $qtPendCateg",
                        style: TextStyle(
                            fontSize: 13, color: Colors.black.withOpacity(0.5)),
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    border: Border.all(color: Colors.grey[500], width: 1.0)),
                // color: _categories[idx].color,
                height: 100.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ListTile(
                    // trailing: Text("$qtPendCateg"),
                    leading: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[500], width: 0.5),
                          shape: BoxShape.circle,
                          color: _categories[idx].color),
                      child: Icon(_categories[idx].icon, size: 40.0),
                    ),
                    title: Text(_categories[idx].nmCateg,
                        style: TextStyle(fontSize: 24, color: Colors.black87)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  String idCateg;
  String nmCateg;
  IconData icon;
  Color color;

  Category(this.idCateg, this.nmCateg, this.icon, this.color);
}

// Future<File> _getFile() async {
//   final directory = await getApplicationDocumentsDirectory();
//   final file = File("${directory.path}/tasks.json");
//   return file.existsSync() ? file : null;
// }

// Future<String> _readData() async {
//    try {
//       final file = await _getFile();

//       return file.readAsString();
//     } catch (e) {
//       return null;
//     }
// }
