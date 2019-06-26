import 'package:bring2me/login/sigin_email.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

final FirebaseAuth _auth =FirebaseAuth.instance;
final usuReference = FirebaseDatabase.instance.reference().child('usuarios');

class RegisterPage extends StatefulWidget {
  final String title = "Registrate";

  State<StatefulWidget> createState() => new _RegisterPageState();
 }
class _RegisterPageState extends State<RegisterPage> {
   bool passwordVisible = true;

  @override
  void initState() {
    passwordVisible = true;
  }

  final GlobalKey<FormState> _formkey =GlobalKey<FormState>();
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordCOntroller =TextEditingController();
  final TextEditingController _passwordControllerconfir =TextEditingController();
  
  final TextEditingController _nombres = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _ubicacion = TextEditingController();
  final TextEditingController _foto = TextEditingController();

  bool _success;
  String _userEmail;


  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: Text(widget.title),
       backgroundColor: Colors.black,
     ),
     body: Container(
       key: _formkey,
       child: Card(
         child: ListView(
         children: <Widget>[
           SizedBox(height: 30.0,),
           Text('INGRESE SU INFORMACIÓN',style: TextStyle(fontSize: 28, color: Colors.black),),
           SizedBox(height: 50.0,),
          TextFormField(
             controller: _nombres,
             style: TextStyle(fontSize: 18, color: Colors.green),
             decoration: InputDecoration(
               icon: Icon(Icons.person),
               labelText: "Nombres",               
             ),
             validator: (String value){
               if(value.isEmpty){
                 return "Por favor ingrese algun texto";
               }  
             },
           ),
           
           TextFormField(
             controller: _emailController,
             style: TextStyle(fontSize: 18, color: Colors.green),
             decoration: InputDecoration(
               icon: Icon(Icons.email),
               labelText: "Email",               
             ),
             validator: (String value){
               if(value.isEmpty){
                 return "Por favor ingrese algun texto";
               }  
             },
           ),
           TextFormField(
             controller: _passwordCOntroller,
             style: TextStyle(fontSize: 18, color: Colors.green),
             decoration: InputDecoration(
               icon: Icon(Icons.vpn_key),
               labelText: "Contraseña",  
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
               )             
             ),
             obscureText: passwordVisible,
             validator: (String value){
               if(value.isEmpty){
                 return "Por favor ingrese algun texto";
               }
             },
           ),
          TextFormField(
             controller: _passwordControllerconfir,
             style: TextStyle(fontSize: 18, color: Colors.green),
             decoration: InputDecoration(
               icon: Icon(Icons.confirmation_number),
               labelText: "Confirma tu Contraseña",  
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
               )             
             ),
             obscureText: passwordVisible,
             validator: (String value){
               if(value.isEmpty){
                 return "Por favor ingrese algun texto";
               }
             },
           ),
            TextFormField(
             controller: _telefono,
             style: TextStyle(fontSize: 18, color: Colors.green),
             decoration: InputDecoration(
               icon: Icon(Icons.email),
               labelText: "Telefono",               
             ),
             validator: (String value){
               if(value.isEmpty){
                 return "Por favor ingrese algun texto";
               }  
             },
           ),
            TextFormField(
             controller: _direccion,
             style: TextStyle(fontSize: 18, color: Colors.green),
             decoration: InputDecoration(
               icon: Icon(Icons.home),
               labelText: "Direccion",               
             ),
             validator: (String value){
               if(value.isEmpty){
                 return "Por favor ingrese algun texto";
               }  
             },
           ),
            FlatButton(
                  child: Text("Registrar"),
                  color: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    if(_passwordCOntroller.text == _passwordControllerconfir.text){
                        _register();
                        showToast("Registrado Correctamente", 
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SignInEmail())); 
                    }else{
                        showToast("Verifique su contraseña correctamente", 
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        _passwordCOntroller.text = '';
                        _passwordControllerconfir.text = '';
                    }
                  }
                ),
           Container(
             alignment: Alignment.center,
             child: Text(_success == null 
             ? "" 
             : (_success 
                ? "Usuario registrado correctamente " + _userEmail 
                : "Usuario no registrado"
                )
                ),
           )
         ],
       ),
       ),
     ),
  
   );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  void dispose(){
    _emailController.dispose();
    _passwordCOntroller.dispose();
    _nombres.dispose();
    _telefono.dispose();
    _direccion.dispose();
    super.dispose();
  }
/* void _registerInfo(){
     CloudFunctions.instance.call(
          functionName: "agregarUsuario",
          parameters: {
            'uid': _userEmail.,
            'nombres' : _nombres.text,
            'telefono': _telefono.text,
            'direccion':_direccion.text,
            'ubicacion': "",
            'correo' : _emailController.text,
            'clave' : _passwordCOntroller.text,  
            'foto' : null,
            'ultimoacceso' :DateTime.now().toString(),  
                    }
                  );             

} */
  void _register() async {
    final FirebaseUser user =await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordCOntroller.text,
      
    );
    if(user !=null){
      setState(() {
       _success =true;
       _userEmail =user.email; 
       CloudFunctions.instance.call(
          functionName: "actualizarUsuarioBring",
          parameters: {
            'uid': user.uid,
            'nombres' : _nombres.text,
            'telefono': _telefono.text,
            'direccion':_direccion.text,
            'ubicacion': "",
            'correo' : _emailController.text,
            'clave' : _passwordCOntroller.text,  
            'foto' : "",
            'ultimoacceso' :DateTime.now().toString(),  
                    }
                  ); 
    });
      
    }else{
      _success = false;
      
    }
  }
}
