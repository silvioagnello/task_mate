import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class MarketPage extends StatefulWidget {
  final String idCateg;
  MarketPage(this.idCateg);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  TextEditingController _mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String tagOfertas = "ofertas-" + widget.idCateg;
    
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 211, 118, 130),
              Color.fromARGB(255, 253, 181, 168)
            ], begin: Alignment.topLeft, end: Alignment.bottomLeft),
          ),
        );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Ofertas",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 20.0,
                      fontFamily: "LibreBaskerville"),
                ),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("$tagOfertas")
                  .where("ativo", isEqualTo: true)
                  .orderBy("bpos", descending: false)
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    staggeredTiles: snapshot.data.documents.map((doc) {
                      return StaggeredTile.count(doc.data["x"], doc.data["y"]);
                    }).toList(),
                    children: snapshot.data.documents.map((doc) {
                      return FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: doc.data["image"],
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  );
              },
            )
          ],
        )
      ],
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Receba novas ofertas por e-mail"),
          content: TextField(
            controller: _mailController,
            autofocus: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                InputDecoration(labelText: "E-mail", hintText: "Digite e-mail"),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Enviar"),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            )
          ],
        );
      },
    );
  }
}
