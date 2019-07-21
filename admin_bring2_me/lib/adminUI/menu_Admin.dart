import 'package:admin_bring2_me/adminUI/RegistrePerson/registerMotociclista.dart';
import 'package:admin_bring2_me/adminUI/categoriasGeneales/categoriasGenerales_ListView.dart';
import 'package:admin_bring2_me/adminUI/completeCrud/ciudades_ListView.dart';
import 'package:admin_bring2_me/adminUI/pedidos/listPedidos_Admin.dart';
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
             Image.asset("assets/images/logo.jpeg", width:250.0,), 
             SizedBox(height: 10,),
             Text('Crear:', style: TextStyle(fontSize: 20.0,)),
           
            SizedBox(height: 25,),           
             FlatButton(
             child: Text("CIUDADES, PROVEEDORES, CATEGORIAS Y PRODUCTOS", style: TextStyle(fontSize: 12.0),),             
             onPressed: (){  
               Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => ListViewCiudades()));
                   showToast("Bienvenido al Panel de Administrador", 
                   duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);   
             },
           ),
             SizedBox(height: 20,), 
              FlatButton(
                child: Text("CATEGORIAS GENERALES"),             
                onPressed: (){  
                  Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => ListViewCategoriasGeneales()));
                      showToast("Bienvenido al Panel de Categorias Generales", 
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);              
                  
                },
              ),           
             SizedBox(height: 20,), 
              FlatButton(
                child: Text("PEDIDOS"),             
                onPressed: (){  
                  Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => ListViewPedidos()));
                      showToast("Bienvenido al Panel de Pedidos", 
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);              
                  
                },
              ),
             SizedBox(height: 20,), 
              FlatButton(
                child: Text("REGISTRAR MOTOCICLISTAS"),             
                onPressed: (){  
                  Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => RegisterMoto()));
                      showToast("Bienvenido al Panel de registro de motociclistas", 
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