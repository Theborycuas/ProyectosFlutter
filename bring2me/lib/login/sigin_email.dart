import 'package:bring2me/ui/uiAllProduct/productHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


class SignInEmail extends StatefulWidget {
  
  @override
  
  State<StatefulWidget> createState() => new _SignInEmailState();
 }
class _SignInEmailState extends State<SignInEmail> {
   TextEditingController _emailController = TextEditingController();
  TextEditingController _paswordcontroller = TextEditingController();
  bool passwordVisible = true;

  @override
  void initState() {
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: Text("Iniciar sesion"),
       backgroundColor: Colors.black,
     ),
     body: Container(
       padding: EdgeInsets.only(bottom: 30.0),
       child: ListView(
         children: <Widget>[
           Image.asset("assets/images/logo.png"),
           //Espacios
           TextField(
             controller: _emailController,
             decoration: InputDecoration(
               labelText: 'Email',
               icon: Icon(Icons.email)
             ),
           ),
           SizedBox(height: 15.0,), 
            TextField(
             controller: _paswordcontroller,
             decoration: InputDecoration(
               labelText: 'Contraseña',
               icon: Icon(Icons.vpn_key),
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
           ),
           SizedBox(height: 15.0,), 
           FlatButton(
             child: Text("Login"),
             color: Colors.black,
             textColor: Colors.white,
             onPressed: (){
               FirebaseAuth.instance.signInWithEmailAndPassword(
                 email: _emailController.text,
                 password: _paswordcontroller.text,
               ).then((FirebaseUser user){
 
              Firestore.instance.collection('usuarios').document(user.uid).get().then((DocumentSnapshot usuarioDoc){
                  Navigator.push(context, MaterialPageRoute(
                       builder: (context) => ProductHomePage(usu:null,))); 
              });
               }).catchError((e){
                 print(e);
               });
             },
           ),

         ],
       ),
     ),
  
   );
  }
}