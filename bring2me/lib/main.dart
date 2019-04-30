import 'package:bring2me/googleMaps/maps.dart';
import 'package:bring2me/googleMaps/mapsTest.dart';
import 'package:bring2me/loginPage.dart';
import 'package:bring2me/ui/HomePage-CategoriasPrin/List_Categorias_Princ.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
   home: FirstPage(),
  ));
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => new _FirstPageState();
 }
class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: Text('Bring2Me'),
       backgroundColor: Colors.black,
     ),
     body: Container(
       child: ListView(
         
         children: <Widget>[
           SizedBox(
             height: 300.0,
           ),
           RaisedButton(
             child: Text('Iniciar Sesion'),
             onPressed: (){ 
               Navigator.push(context, MaterialPageRoute(
                 builder: (context) => MyAppLoginPage()
               ));
               
             },
           )
         ],
       ),
     ),

  
   );
  }
}