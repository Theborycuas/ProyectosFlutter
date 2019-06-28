import 'package:bring2me/ui/uiAllProduct/productHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CompleteInfo extends StatefulWidget {
  const CompleteInfo({Key key, @required this.usu}) : super(key: key);
  final FirebaseUser usu;

  _CompleteInfoState createState() => _CompleteInfoState();
}
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _ubicacionController = TextEditingController();

class _CompleteInfoState extends State<CompleteInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ingrese su Informacion"),
      ),
      body: Container(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child:  Text("Ingresa los siguientes datos para conpletar tu información",
                     style: TextStyle(fontSize: 25.0),),
                ),
                SizedBox(
                  height: 35.0,
                ),
                TextFormField(
                  controller: _telefonoController,
                  style: TextStyle(fontSize: 18, color: Colors.green),
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: "Telfono",               
                  ),
                  keyboardType: TextInputType.number,
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
                    icon: Icon(Icons.map),
                    labelText: "Dirección",               
                  ),
                  validator: (String value){
                    if(value.isEmpty){
                      return "Por favor ingrese algun texto";
                    }  
                  },
                ),
                TextFormField(
                  controller: _ubicacionController,
                  style: TextStyle(fontSize: 18, color: Colors.green),
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    labelText: "Ubicación",               
                  ),
                  validator: (String value){
                    if(value.isEmpty){
                      return "Por favor ingrese algun texto";
                    }  
                  },
                ),               
                SizedBox(
                  height: 35.0,
                ),
                FlatButton(
                  child: Text("Guardar"),
                  onPressed: (){
                    updateUserDatabase(widget.usu, _telefonoController, _direccionController, _ubicacionController);
                   
                    Firestore.instance.collection('usuarios').document(widget.usu.uid).get().then((DocumentSnapshot usuarioDoc){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ProductHomePage(usu:widget.usu,))); 
                          showToast("Bienvenido a BRING2ME ${usuarioDoc.data["nombres"]}", context, 
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);  
                      });
                  },
                )
                

              ],
            ),
          ),
    );
  }
 void updateUserDatabase(FirebaseUser user, TextEditingController telefono, TextEditingController direccion,
 TextEditingController ubicacion)async{

            CloudFunctions.instance.call(
              functionName: "actualizarUsuarioBring",
              parameters: {
                                'uid' : user.uid,
                                'nombres' : user.displayName,
                                'telefono': telefono.text,
                                'direccion': direccion.text,
                                'ubicacion': ubicacion.text,
                                'correo' :user.email,
                                'clave' :user.uid,  
                                'foto' :user.photoUrl,
                                'ultimoacceso' : DateTime.now().toString(),                         

                    }
                  );   
  }
  void showToast(String msg, BuildContext context, {int duration, int gravity}) 
  {
    Toast.show(msg, context, duration: duration, gravity: gravity);
   }
}