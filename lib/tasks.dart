import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:dots_indicator/dots_indicator.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_mate/helper.dart';
import 'package:task_mate/market.dart';

int numPage;
String versionSale = '1';

class Categ {
  String idCateg;
  String nmCateg;
  String txtTarefa;
  bool ok;

  Categ(this.idCateg, this.nmCateg, this.txtTarefa, this.ok);
}

class TasksPage extends StatefulWidget {
  final Color colorCateg;
  final String idCateg;

  TasksPage({this.colorCateg, this.idCateg});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _toDoController = TextEditingController();
  String logo;
  String ofertas = "";
  List _toDoList = [];
  List _toDoList2 = [];
  bool buttonChanged = false;
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;
  FocusNode _focusNode;

  Helper helper = new Helper();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    sleep(const Duration(milliseconds: 10));

    helper.readData().then((data) {
      setState(() {
        if (data != null) {
          _toDoList = json.decode(data);
          _toDoList2 = json.decode(data);

          _toDoList2.removeWhere((c) => c["idCateg"] == widget.idCateg);
          _toDoList.removeWhere((c) => c["idCateg"] != widget.idCateg);

          buttonChanged = false;

          _refresh2();
        }

        helper.getlogo(widget.idCateg).then((data) {
          setState(() {
            if (data != null) {
              logo = data;
              // ofertas = "logo";
            } else {
              ofertas = "";
            }
          });
        });

        helper.getofertas(widget.idCateg).then((data) {
          if (data != null) {
            setState(() {
              ofertas = data;
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.colorCateg,
          automaticallyImplyLeading: false,
          leading: InkWell(
              child:
                  Icon(Icons.arrow_back, color: Colors.black.withOpacity(0.5)),
              onTap: () {
                _sendDataBack(context);
              }),
          title: Text(
            nmCateg(widget.idCateg),
            style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 20.0,
                fontFamily: "LibreBaskerville"),
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    border: Border.all(color: Colors.grey[500], width: 1.0)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _toDoController,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              hintText: "Digite uma tarefa",
                              labelStyle: TextStyle(color: Colors.blue))),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        color: Colors.lightBlueAccent,
                        child: Icon(
                          Icons.check,
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          return _addToDo();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _toDoList.length > 0
                  ? Text(
                      "Arraste a tarefa à direita para eliminar",
                      style: TextStyle(
                          fontSize: 12.0, color: Colors.black.withOpacity(0.5)),
                    )
                  : Text(""),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 8.0),
                    itemCount: _toDoList.length,
                    itemBuilder: buildItem),
              ),
            )
          ],
        ),
        bottomNavigationBar: buildBottomNavigationBar(widget.idCateg),
      ),
    );
  }

  Widget buildItem(context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
          color: Colors.red,
          child: Align(
              alignment: Alignment(-0.9, 0.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ))),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
          title: Text(_toDoList[index]['txtTarefa']),
          value: _toDoList[index]["ok"],
          secondary: CircleAvatar(
              child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error)),
          onChanged: (c) {
            setState(() {
              _toDoList[index]["ok"] = c;
              buttonChanged = true;
              _saveData();
            });
          }),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);
          buttonChanged = true;
          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa ${_lastRemoved['nmCateg']} removida"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _toDoList.insert(_lastRemovedPos, _lastRemoved);
                  buttonChanged = true;
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 7),
          );
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  String nmCateg(idCateg) {
    String nmCateg;
    switch (idCateg) {
      case "0":
        nmCateg = 'MERCADO';
        break;
      case "1":
        nmCateg = 'FARMÁCIA';
        break;
      case "2":
        nmCateg = 'CONSTRUÇÃO';
        break;
      case "3":
        nmCateg = 'TAREFAS';
        break;
      case "4":
        nmCateg = 'AUTOMÓVEL';
        break;
      case "5":
        nmCateg = 'ROUPAS';
        break;
      case "6":
        nmCateg = 'OUTROS';
        break;
      default:
        nmCateg = 'EXTRA';
    }
    return nmCateg;
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newTask = {
        "idCateg": "${widget.idCateg}",
        "nmCateg": nmCateg(widget.idCateg),
        "txtTarefa": _toDoController.text,
        "ok": false
      };
      buttonChanged = true;
      if (_toDoController.text != "") {
        _toDoController.text = "";
        _toDoList.add(newTask);
        _saveData();
      }
    });
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (buttonChanged) {
      return showDialog(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: Text('Para voltar...'),
              content: Text('Clique no botão na barra superior'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Continuar'),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      return true;
    }
  }

  changeDot(int num) {
    setState(() {
      numPage = num;
      return numPage;
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });
    });
    return null;
  }

  Future<Null> _refresh2() async {
    await Future.delayed(Duration(seconds: 1));
    // setState(() {
    _toDoList.sort((a, b) {
      if (a["ok"] && !b["ok"])
        return 1;
      else if (!a["ok"] && b["ok"])
        return -1;
      else
        return 0;
    });
    return null;
  }

  Future<File> _saveData() async {
    var newMyList = _toDoList + _toDoList2;
    // _toDoList2 = [];
    String data = json.encode(newMyList); //
    File file = await helper.getFile();
    return file.writeAsString(data);
  }

  _sendDataBack(BuildContext context) {
    String textToSendBack = _toDoList.length.toString();
    Navigator.pop(context, textToSendBack);
  }
// }

  Widget buildBottomNavigationBar(String idCateg) {
    if (logo == null) // || versionSale == '0')
    {
      return null;
    } else {
      return BottomAppBar(
        child: Stack(
          children: <Widget>[
            Container(
              height: 130,
              width: double.infinity,
              child: Image.network(
                "$logo",
                fit: BoxFit.fill,
              ),
            ),
            Positioned(top: 5, right: 8.0, child: buildFlatButton()),
          ],
        ),
      );
    }
  }

  buildFlatButton() {
    if (ofertas != "") {
      return RaisedButton(
        //animationDuration: Duration(milliseconds: 500),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)), //CircleBorder(),
        elevation: 4,
        child: Text(
          "ver ofertas",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 17, color: Colors.black),
        ), //Icon(Icons.add),
        onPressed: () {
          // if (numPage == 0) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MarketPage(widget.idCateg)));
          // }
        },
        color: Colors.redAccent,
        // color: Colors.black38,
        textColor: Colors.black,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        splashColor: Colors.grey,
      );
    } else {
      return Container(); //null;
    }
  }
}
