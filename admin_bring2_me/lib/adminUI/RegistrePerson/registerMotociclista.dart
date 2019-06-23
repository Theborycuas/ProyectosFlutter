import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterMoto extends StatefulWidget {
  RegisterMoto({Key key}) : super(key: key);

  _RegisterMotoState createState() => _RegisterMotoState();
}

class _RegisterMotoState extends State<RegisterMoto> {
  bool passwordVisible = true;

  @override
  void initState() { 
    super.initState();
    passwordVisible = true;
    
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _fotoControllers = TextEditingController();

  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Motociclista"),
      ),
      body: Container(
        key: _formkey,
        child: Card(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30.0,),
              Center(
                child: Text("Ingrese los datos del Motociclista", style: TextStyle(fontSize: 20.0),),
              ),              
              SizedBox(height: 50.0,),
              TextFormField(
                controller: _nombresController,
                style: TextStyle(fontSize: 18.0, color: Colors.green),
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: "Nombres"
                ),
                validator: (String value){
                  if(value.isEmpty){
                    return "Por favor ingrese el nombre del motociclista";
                  }
                },
              ),
              TextFormField(
                controller: _emailController,
                style: TextStyle(fontSize: 18.0, color: Colors.green),
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: "Email"
                ),
                validator: (String value){
                  if(value.isEmpty){
                    return "Por favor ingrese el email del motociclista";
                  }
                },
              ),
              TextFormField(
                controller: _passwordController,
                style: TextStyle(fontSize: 18.0, color: Colors.green),                
                decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  labelText: "Contraseña",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color:  Theme.of(context).primaryColorDark,
                    ),
                    onPressed: (){
                      setState(() {
                       passwordVisible ? passwordVisible = false : passwordVisible = true; 
                      });
                    },
                  )
                ),
                obscureText: passwordVisible,
                validator: (String value){
                  if(value.isEmpty){
                    return "Por favor ingrese la contraseña";
                  }
                },
              ),
              TextFormField(
                controller:  _passwordConfirmController,
                style: TextStyle(fontSize: 18, color: Colors.green),
                decoration: InputDecoration(
                  icon:  Icon(Icons.confirmation_number),
                  labelText: "Confirma la contraseña",
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
                controller: _telefonoController,
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
                controller: _direccionController,
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
                      if(_passwordController.text == _passwordConfirmController.text){
                          _register();
                         
                    
                      }else{
                          showToast("Verifique su contraseña correctamente", 
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          _passwordController.text = '';
                          _passwordConfirmController.text = '';
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
        )
      ),
    );
  }
  void showToast(String msg, {int duration, int gravity}) 
  {
      Toast.show(msg, context, duration: duration, gravity: gravity);
      }

  void dispose(){
      _emailController.dispose();
      _passwordController.dispose();
      _nombresController.dispose();
      _telefonoController.dispose();
      _direccionController.dispose();
      super.dispose();
    }
  void _register() async {
      final FirebaseUser user =await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if(user !=null){
        setState(() {
        _success =true;
        _userEmail =user.email; 
        CloudFunctions.instance.call(
            functionName: "actualizarMotociclista",
            parameters: {
              'uid': user.uid,
              'nombres' : _nombresController.text,
              'telefono': _telefonoController.text,
              'direccion':_direccionController.text,
              'correo' : _emailController.text,
              'clave' : _passwordController.text,  
              'foto' : "",
              'ultimoacceso' :DateTime.now().toString(),  
                      }
                    ); 
         showToast("Registrado Correctamente", 
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _nombresController.text = "";
        _telefonoController.text = "";
        _direccionController.text = "";
        _emailController.text = "";
        _passwordController.text = "";
        _passwordConfirmController.text = "";
        _fotoControllers.text = "";

      });
        
      }else{
        _success = false;
        
      }
    }

}
