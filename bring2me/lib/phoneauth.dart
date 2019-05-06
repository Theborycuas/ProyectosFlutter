import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => new _PhoneAuthState();
 }
class _PhoneAuthState extends State<PhoneAuth> {
  
  String phoneNo;
  String smsCode;
  String verificationId;

  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: Text("PhoneAuth"),),
       body: Center(
         child: Container(
           padding: EdgeInsets.all(25.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               TextField(
                 decoration: InputDecoration(hintText: "Ingrese su numero de telefono"),
                 onChanged: (value){
                   this.phoneNo = value;
                 },
               ),
               SizedBox(height: 10.0,),
               RaisedButton(
                 onPressed: verifyPhone,
                 child: Text("Verificar"),
                 textColor: Colors.white,
                 elevation: 7.0,
                 color: Colors.blue,
               )

             ],
           ),
         ),
       ),
  
   );
  }

  Future<void> verifyPhone()async{
    
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]){
      this.verificationId = verId;
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user){
      print('verified');
    };

    final PhoneVerificationFailed verifiFailed = (AuthException exception){
      print('${exception.message}');

    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout:  const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifiFailed
    );
  }
  Future<bool> smsCodeDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Ingrese el codigo del SMS"),
          content: TextField(
            onChanged: (value){
              this.smsCode = value;
            },
          ), 
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            FlatButton(
              child: Text("Done"),
              onPressed: (){
                FirebaseAuth.instance.currentUser().then((user){
                  if(user != null){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  }
                  else{
                    Navigator.of(context).pop();
                  }

                });
              },
            )
          ],

        );
      }

    );
  }

/*   signIn(){
    FirebaseAuth.instance.p
  } */
}