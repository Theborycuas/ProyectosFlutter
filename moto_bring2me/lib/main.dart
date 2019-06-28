import 'package:flutter/material.dart';
import 'package:moto_bring2me/homePageMoto.dart';

void main() {
  runApp(
     MaterialApp(
    debugShowCheckedModeBanner: false,
   home: FirstPage(),
   title: "Bring2Me"
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
       title: Text('Bring2Me - Motociclistas'),
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
                  builder: (context) => HomePageMoto(docUsu: null,) 
               )); 
             },
           ),
         ],
       ),
     ),
   );
  }
}