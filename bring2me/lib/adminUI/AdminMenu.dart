import 'package:bring2me/adminUI/AdminListPedidos.dart';
import 'package:bring2me/adminUI/AdminListview_categoria.dart';
import 'package:bring2me/adminUI/AdminListview_product.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


class Menu extends StatefulWidget {
  @override
  _MenuState createState() => new _MenuState();
 }
class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: Text("Menu Admin"),
     ),
     body: Container(
       child: Center(
         child: Column(
           children: <Widget>[
             SizedBox(height: 5,),
             Image.asset("assets/images/logo.png"), 
             SizedBox(height: 20,),
             RaisedButton(
             child: Text("CATEGORIAS"),             
             onPressed: (){  
               Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => ListViewCategoria()));
                  
               
             },
           ),
            SizedBox(height: 20,),
             RaisedButton(
             child: Text("PRODUCTOS"),             
             onPressed: (){ 
                   Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => ListViewProduct()));
                   showToast("Bienvenido al Panel de Productos", duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
             }
             ),           
            SizedBox(height: 20,),             
             RaisedButton(
             child: Text("PEDIDOS"),             
             onPressed: (){  
               Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => AdminPedidos()));
                   showToast("Bienvenido al Panel de Pedidos", 
                   duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);              
               
             },
           ),

           ],
         ),
       ),
     ),
  
   );
  }
    void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
} 