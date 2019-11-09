import 'package:flutter/material.dart';
import 'package:order_restaurant/crearProducto.dart';

void main() {
  runApp(new MaterialApp(
   home: FirstPage(),
   debugShowCheckedModeBanner: true,
  ));
}

class FirstPage extends StatefulWidget {
  FirstPage({Key key}) : super(key: key);

  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("El Buque"),
       ),
       body: Container(
         child: ListView(
           children: <Widget>[
             FlatButton(
               child: Text("Crear Producto"),
               onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                   builder: (context) => MyHomePage()
                 )); 
               },
             )
           ],
         ),
       ),
    );
  }
}