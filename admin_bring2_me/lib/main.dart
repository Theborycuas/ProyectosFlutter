import 'package:admin_bring2_me/adminUI/loginAdmin.dart';
import 'package:admin_bring2_me/adminUI/menu_Admin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,

   home: FirstPage(),
   title: "AdminBring2Me",
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
       title: Text('Bring2MeAdmin'),
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
                 builder: (context) => Menu()
                 /* builder: (context) => InicioAdmin() */
                 
               )
               );               
             },
           ),
           
         ],
       ),
     ),  
   );
  }
}