import 'dart:math';
import 'package:bring2me/ui/HomePage-CategoriasPrin/List_Categorias_Princ.dart';
import 'package:bring2me/ui/HomePage-CategoriasPrin/homePageUsu.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {

//google signIn
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final Firestore _db = Firestore.instance;
PublishSubject loading = PublishSubject();

bool isLogIn = false;


Observable<FirebaseUser> user;
Observable<Map<String, dynamic>> profile;
  bool _success;
  String _userID;

  AuthService(){
    user =Observable(_auth.onAuthStateChanged);
    profile = user.switchMap((FirebaseUser u){
      if(u !=null){
        return _db.collection('usuarios').document(u.uid).snapshots().map((snap) => snap.data);
      }else{
        return Observable.just({});
      }


    });

  }
  
  Future<bool> googleSignIn(BuildContext context) async{

    

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =await googleUser.authentication;
    
    Observable<Map<String, dynamic>> profile;
    
    loading.add(true) ;
 
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.displayName != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid ==currentUser.uid);
    
     if(user != null) {
              _success = true;
              _userID = user.uid;
             updateUserDatabase(user, context);
             loading.add(false);
             Firestore.instance.collection('usuarios').document(user.uid).get().then((DocumentSnapshot usuarioDoc){
                  Navigator.push(context, MaterialPageRoute(
                       builder: (context) => ListCategoriaPrincipal(user:user, usuDoc: usuarioDoc,))); 
              });
               isLogIn = true;
     }
     return isLogIn;
     
  }

   void updateUserDatabase(FirebaseUser user, BuildContext context)async{

            CloudFunctions.instance.call(
              functionName: "actualizarUsuarioBring",
              parameters: {
                                "doc_id": user.uid,
                                'uid' : user.uid,
                                'nombres' : user.displayName,
                                'telefono': user.phoneNumber,
                                'direccion':'',
                                'ubicacion': '',
                                'correo' :user.email,
                                'clave' :user.uid,  
                                'foto' :user.photoUrl,
                                'ultimoacceso' :DateTime.now().toString(),                         

                    }
                  );   
  }
//Cerrar sesion
  Future<void> signOut(BuildContext context) async{
   await _auth.signOut();
/*    Navigator.of(context).pushReplacement(CupertinoPageRoute(
         builder: (context) => LoginPage(),
       )); */
  }
}

final AuthService authService =AuthService();