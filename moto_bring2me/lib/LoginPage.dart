import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moto_bring2me/homePageMoto.dart';
import 'package:toast/toast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
class LoginMotociclistas extends StatefulWidget {
  //LoginMotociclistas({Key key}) : super(key: key);

  _LoginMotociclistasState createState() => _LoginMotociclistasState();
}

class _LoginMotociclistasState extends State<LoginMotociclistas> {
  TextEditingController _usuario = TextEditingController();
  TextEditingController _clave = TextEditingController();
  bool passwordVisible = true;
  @override
  void initState() {
    passwordVisible = true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text("Inicio Sesion Admin"),

     ),
     body: Container(
       child: Card(
           child: ListView(
           children: <Widget>[
             
           Image.asset("assets/images/logo.jpeg",width: 20,), 
           TextField(controller: _usuario,
              style: TextStyle(fontSize: 18.0, color: Colors.green),
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Usuario'
           ),),
           SizedBox(height: 10,),
           TextField(
             keyboardType: TextInputType.emailAddress,
             
             controller: _clave,
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
                 _signInEmail(context);
             },
           )
           ],
         ),
         ),
     ),
  
   );
  }
  Future<Null> _signInEmail(BuildContext context) async{
    FirebaseUser user;

    try {
      user = await _auth.signInWithEmailAndPassword(
          email: _usuario.text,
          password: _clave.text,
      );
    } catch (e) {
      print(e.toString());
    }
    finally {
      if (user != null) {
        // sign in successful!
            Firestore.instance.collection('motociclistas').document(user.displayName).get().then((DocumentSnapshot usuarioDoc){
               Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HomePageMoto(docUsu: usuarioDoc,)));
              showToast("Bienvenido a BRING2ME ${usuarioDoc.data["nombres"]}", context, 
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);  
       });
      } else {
        // sign in unsuccessful
        showToast("Clave o contraseña incorrecta", context, 
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);  
        print('sign in Not');
      }
    }
  }
  void showToast(String msg, BuildContext context, {int duration, int gravity}) 
  {
    Toast.show(msg, context, duration: duration, gravity: gravity);
   }    

}