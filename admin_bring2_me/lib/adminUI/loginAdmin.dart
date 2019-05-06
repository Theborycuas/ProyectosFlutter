import 'package:admin_bring2_me/adminUI/menu_Admin.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


class InicioAdmin extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Oreganos Pizza",
      home: SesionAdmin(title: "Oreganos Pizzas",),

  
 );
 }
}

class SesionAdmin extends StatefulWidget {  
  final String title;
  SesionAdmin({Key key, this.title}) :super(key:key);

  @override
  _SesionAdminState createState() => new _SesionAdminState();
 }

 TextEditingController _usuario = TextEditingController();
 TextEditingController _clave = TextEditingController();
 
 String usuario = "admin";
 String clave = "12345";

class _SesionAdminState extends State<SesionAdmin> {
   bool passwordVisible = true;
  @override
  void initState() {
    passwordVisible = true;
  }
  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: Text("Inicio Sesion Admin"),

     ),
     body: Container(
       child: Card(
           child: ListView(
           children: <Widget>[
             
           Image.asset("assets/images/logo.png"), 
           TextField(controller: _usuario,
              style: TextStyle(fontSize: 18.0, color: Colors.green),
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Usuario'
           ),),
           SizedBox(height: 10,),
           TextField(controller: _clave,
              style: TextStyle(fontSize: 18.0, color: Colors.green),
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_key),
                labelText: 'Clave',
                suffixIcon: IconButton(
                 icon: Icon(
                   passwordVisible
                   ? Icons.visibility
                   : Icons.visibility_off,
                   color: Theme.of(context).primaryColorDark,
                 ),
                 onPressed: (){
                   setState(() {
                    passwordVisible
                    ? passwordVisible = false
                    : passwordVisible = true;
                   });
                 },
               ),       
              ),              
              obscureText: passwordVisible,
           ),
           SizedBox(height: 20,),
           
           RaisedButton(
             child: Text("INGRESAR"),             
             onPressed: (){ 
               
                _ingresar();
             },
           )
           ],
         ),
         ),
     ),
  
   );
  }

  void _ingresar() async{
    if(_usuario.text == usuario || _clave.text == clave){
      Navigator.push(context, 
        MaterialPageRoute(builder: (context) => Menu()));
      showToast("Ingreso Exitoso", duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _clave.text = "";
      _usuario.text = "";
    }else{
      showToast("Usuario o Clave Inconrrectos", duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _clave.text = "";
      _usuario.text = "";
    }
    /* Navigator.push(context, 
        MaterialPageRoute(builder: (context) => ListViewProductPizza()));
        showToast("Ingrese El usuario o contraseña", duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM); */
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}