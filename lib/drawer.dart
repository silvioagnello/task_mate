import 'package:flutter/material.dart';


class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.blue[300],
                Colors.blue[200],
                Colors.blue[100],
                Colors.blue[50],
              ],
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 28.0, top: 26.0, right: 22.0),
            children: <Widget>[
              Container(
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.grey[500], width: 0.5),
                // ),
                height: 200.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: 70.0,
                          left: 70.0,
                          child: Container(
                            width: 100.0,
                            child: Image.asset(
                              "assets/icons/RoundIcons-Free-Set-16.png",
                              fit: BoxFit.cover,
                            ),
                          )),
                      Positioned(
                        top: 10.0,
                        left: 30.0,
                        child: Text(
                          "Task-Mate",
                          style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Divider(),
              // DrawerTile(Icons.help, "Ajuda", pageController, 1),
              // DrawerTile(Icons.perm_media, "Sobre", pageController, 2),

            ],
          )
        ],
      ),
    );
  }
}
