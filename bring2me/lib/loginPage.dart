import 'package:bring2me/adminUI/loginAdmin.dart';
import 'package:bring2me/login/register_page.dart';
import 'package:bring2me/login/sigin_email.dart';
import 'package:bring2me/login/signin_google_perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
 }
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: Text('INICIAR SESIÓN'),
       backgroundColor: Colors.black,
     ),
     body: Container(    
       padding: EdgeInsets.all(30.0),
       child: Row(
         children: <Widget>[    
           //Columna basia espacio       
          Column(
          children: [
            SizedBox(width: 30.0,), 
          ],
        ),
          Column(    
                 
        // mainAxisAlignment: MainAxisAlignment.center,
        //Logo
         children: <Widget>[
           Image.asset("assets/images/logo.png", width: 200.0,),  
           SizedBox(height: 30.0,), 
           Text("Continuar con:"),
           SizedBox(height: 15.0,),  
            GoogleSignInButton(
             onPressed: (){ 
               authService.googleSignIn(context);
               darkMode: true;
             }, 
             darkMode: true
           ),
           Text("or"),
           SizedBox(height: 10.0),
           SizedBox(
             height: 40.0,
             width: 220,
             child: RaisedButton(
                  child: Text("REGISTRATE CON TU E-MAIL"),
                  color: Colors.black,
                  textColor: Colors.white,
                  onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => RegisterPage()
                      ));                    
                  },
                  
             ),),  
            SizedBox(height: 90.0),
            SizedBox(
             height: 40.0,
             width: 220,
             child: RaisedButton(
               child: Text("INICIAR SESIÓN"),
             color: Colors.white,
            textColor: Colors.black,
            onPressed: (){
               Navigator.push(context, MaterialPageRoute(
                 builder: (context) => SignInEmail()
               ));
            },
                                     
             ),),             

         ],
         
       ),
       
       Column(
         children: <Widget>[
           SizedBox(height: 572.0,),
            
             SizedBox( 
                         
              width: 30.0,
              height: 10.0,
              child: new RaisedButton(
                
                padding: EdgeInsets.only(left: 0, right: 0),
                child: Text('Adm', style: TextStyle(fontSize: 6),),
                color: Colors.white,
                textColor: Colors.green,
                onPressed: (){
                  
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => InicioAdmin()
                    ));
                  
                },
               
              ),
            ),
         ],
         

       )
         ],
       ),
       
     ),  
   );
  }
}