import 'package:bring2me/login/signin_google_perfil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ListViewProductUsu extends StatefulWidget {
  const ListViewProductUsu({Key key, @required this.cat , this.user}) : super(key: key);  
  final DocumentSnapshot cat;
  final FirebaseUser user;

  @override
  _ListViewProductUsuState createState() => new _ListViewProductUsuState();
 }
 
class _ListViewProductUsuState extends State<ListViewProductUsu> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(

        title: Text('PRODUCTOS'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.menu),
          onPressed: (){
            
          },)
        ],
      ),
      body: Center(
        child: _recuperarProductos(),
      ),
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarProductos() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categoria').document(widget.cat.documentID).collection('producto').snapshots(),      
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("No existen Productos creados.");
            //print(logger);
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final productDoc = snapshot.data.documents[index];
                                   

                  return Dismissible( // <--------------------------NEW CODE-----------------
                    key: new Key(snapshot.data.documents[index].documentID),
                    direction: DismissDirection.horizontal,
                    onDismissed: (DismissDirection direction) {
                      if (direction != DismissDirection.horizontal) {
                          Firestore.instance.collection('categoria').document(widget.cat.documentID).collection('producto').document(productDoc.documentID).delete();
                      }
                    },
                    child: InkWell(
                       onTap:() { _verProductoDialog(context, productDoc); },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(productDoc['nombre_pro']),
                                      subtitle: new Text(productDoc['descripcion_pro']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${productDoc['imagen_pro']}', width: 40),
                                      ],
                                    ),
                                 ),
                               ),   
                                IconButton(
                                icon: Icon(Icons.add_shopping_cart),
                                onPressed: () { _verProductoDialog(context, productDoc); }
                                )                            
                             ],
                             
                             
                           ),

                         ],
                         
                       )
                    )
                  );
              }
          );

        }
    );

  }
  

  Future<Null> _verProductoDialog(BuildContext context, DocumentSnapshot productDoc) {
     Firestore.instance.collection('usuarios')
        .document(widget.user.uid).get().then((DocumentSnapshot userDoc) {
   
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text('${productDoc['nombre_pro']}', style: TextStyle(fontSize: 30.0),),
              content: Container(
                height: 420.0,
                width: 100.0,
                child: ListView(
                  children: <Widget>[
                    SizedBox(                          
                            width: 250.0,
                            height: 150.0,
                            child: Image.network('${productDoc['imagen_pro']}', width: 40),     
                    ),//imagen               
                  Padding(padding: EdgeInsets.only(top: 15.0),),
                  Divider(),
                  Text("Descripcion", style: TextStyle(fontSize: 15.0),),
                    Text('${productDoc['descripcion_pro']}', style: TextStyle(fontSize: 20.0),),
                    Padding(padding: EdgeInsets.only(top: 15.0),),
                  Divider(),
                  Text("Precio", style: TextStyle(fontSize: 15.0),),
                    Text(' ${productDoc['precio_pro']}', style: TextStyle(fontSize: 20.0),),
                
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancelar")
                ), 
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: (){
                      CloudFunctions.instance.call(
                        functionName: "crearPedido",
                        parameters: {
                          "doc_id": widget.user.uid,
                          "uid": productDoc['uid'],
                          "nombre": productDoc['nombre'],
                          "descripcion": productDoc['descripcion'],
                          "precio": productDoc['precio'],
                          "imagen": productDoc['imagen'],
                        }
                      );
                      /* CloudFunctions.instance.call(
                        functionName: "crearPedidoAdmin",
                        parameters: {
                          "nombres": widget.user.displayName,
                          "correo": widget.user.email,
                          "telefono":userDoc.data['telefono'],
                          "direccion":userDoc.data['direccion'],
                          "ubicacion":userDoc.data['ubicacion'],
                          "nombrePizza": pizzaDoc['nombre'],
                          "descripcion": pizzaDoc['descripcion'],
                          "precio": pizzaDoc['precio'],
                          "imagen": pizzaDoc['imagen'],
                        }
                      ); */

                  },)
              ],
            );
          }
        );
        });
        

  } 
}