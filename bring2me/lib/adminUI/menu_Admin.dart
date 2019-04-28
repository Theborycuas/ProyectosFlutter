
import 'package:bring2me/adminUI/Categoria/categoria_AdminListview.dart';
import 'package:bring2me/adminUI/Categoria/ciudad_CatListView.dart';
import 'package:bring2me/adminUI/Ciudades/ciudad_AdminListview.dart';
import 'package:bring2me/adminUI/Productos/ciudad_ProdListView.dart';
import 'package:bring2me/adminUI/Productos/product_AdminListview.dart';
import 'package:bring2me/adminUI/Proveedores/ciudad_ProvListView.dart';
import 'package:bring2me/adminUI/listPedidos_Admin.dart';
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
             Image.asset("assets/images/logo.png", width:300.0,), 
             SizedBox(height: 10,),
             Text('Crear:', style: TextStyle(fontSize: 30.0,)),
             SizedBox(height: 15,),
             FlatButton(
             child: Text("CIUDAD"),             
             onPressed: (){ 
                   Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => ListViewCiudad()));
                   showToast("Bienvenido al Panel de Ciudad", duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
             }
             ),     
             SizedBox(height: 10,),
             FlatButton(
             child: Text("PROVEEDORES"),             
             onPressed: (){ 
                   Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => ListViewProveedor()));
                   showToast("Bienvenido al Panel de Proveedor", duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
             }
             ),              
             SizedBox(height: 10,),
             FlatButton(
             child: Text("CATEGORIAS"),             
             onPressed: (){  
               Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => ListViewProveedorCat()));
                   showToast("Bienvenido al Panel de Categoria", duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
               
             },
           ),
             SizedBox(height: 10,),
             FlatButton(
             child: Text("PRODUCTOS"),             
             onPressed: (){ 
                   Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => ListViewProveedorProd()));
                   showToast("Bienvenido al Panel de Productos", duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
             }
             ),           
             SizedBox(height: 10,),           
             FlatButton(
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