import 'package:flutter/material.dart';
import 'package:xtrema/screens/programas.dart';
import 'package:xtrema/screens/concurso.dart';
import 'package:xtrema/screens/servicios.dart';

class SideBar extends StatefulWidget {
  SideBar({Key key}) : super(key: key);

  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
                  child: Text('RADIO XTREMA'),
                ),
                Text('Dirección: [Dirección]'),
                Text('Teléfono: [Teléfono]'),
                Text('Correo: [Correo]'),
              ],
            ),
            // decoration: ,
          ),
          ListTile(
            title: Text(''),
            onTap: null,
            subtitle: Text('MENU'),
          ),
          ListTile(
            title: Text('Programas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Programaswidget()));
            },
          ),
          ListTile(
            title: Text('Concurso'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Concursowidget()));
            },
          ),
          ListTile(
            title: Text('Servicios'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Servicioswidget()));
            },
          ),
        ],
      ),
    );
  }
}
