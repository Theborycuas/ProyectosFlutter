import 'package:bring2me/loginPage.dart';
import 'package:flutter/material.dart';

class FavoriteProducts extends StatefulWidget {
  @override
  _FavoriteProductsState createState() => new _FavoriteProductsState();
 }
class _FavoriteProductsState extends State<FavoriteProducts> {
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
                 builder: (context) => MyAppLoginPage(usuDoc: null, user: null,)
               ));
             },
           ),
         ],
       ),
     ),
   );
  } 
}
