import 'package:bring2me/loginPage.dart';
import 'package:bring2me/ui/uiAllProduct/productHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
          
  runApp(
     MaterialApp(
    debugShowCheckedModeBanner: false,
   home: _getLandingPage(),
   title: "Bring2Me"
  ));
}
 

 Widget _getLandingPage() {  

  return StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder:  (BuildContext context, snapshot)  {
     
          if (snapshot.data != null) {
              return ProductHomePage(usu: snapshot.data);
            } else {
                return MyAppLoginPage();
              }        
       /* DocumentSnapshot docUsu = await Firestore.instance.collection("usuarios").document(snapshot.data.displayName).get();          */         
    },
  );
}  




/* 
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => new _FirstPageState();
 }
class _FirstPageState extends State<FirstPage> {
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
}   */
/* 
 Firestore.instance.collection('usuarios').document(widget.usu.displayName).get().then((DocumentSnapshot usuarioDoc){
                      });
 */