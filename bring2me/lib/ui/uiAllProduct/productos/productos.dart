import 'package:bring2me/ui/uiAllProduct/relizar%20pedido/confirmar_direccion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ListProductos extends StatefulWidget {
  const ListProductos({Key key, @required this.catGenDoc, this.proveDoc, 
    this.catProvDoc, this.usu, this.userDoc }) : super(key: key); 

  final DocumentSnapshot catGenDoc;
  final DocumentSnapshot proveDoc;
  final DocumentSnapshot catProvDoc;
  final FirebaseUser usu;
  final DocumentSnapshot userDoc;
  @override
  _ListProductosState createState() => new _ListProductosState();
 }
class _ListProductosState extends State<ListProductos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Productos'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: _recuperarProductos(),
      ),
    );
  }
  StreamBuilder<QuerySnapshot> _recuperarProductos() {

    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document("Esmeraldas").collection('categoriaGen').document(widget.catGenDoc.documentID).collection('proveedor').document(widget.proveDoc.documentID).collection('categoria').document(widget.catProvDoc.documentID).collection('productos').snapshots(),      
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("No existen productos.");
            //print(logger);
            return Container(); 
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final prodDoc = snapshot.data.documents[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
                    child: new Column(
                      children: <Widget>[
                        InkWell(
                          key: new Key(snapshot.data.documents[index].documentID),
                          
                            onTap:() {
                              _verProductDialog(context, prodDoc, widget.usu, widget.userDoc);
                              },
                            child: Container(
                              width: double.infinity,
                              height: 330.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.grey.withOpacity(.3), width: .3)),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  
                                  Image.network("${prodDoc.data["imagen_pro"]}", width: 281.0, height: 191.0),
                                  Text("${prodDoc.data["nombre_pro"]}", style: TextStyle(fontSize: 25.0)),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.favorite_border),
                                          onPressed: () {},
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text("\$ ${prodDoc.data["precio_pro"]}",
                                                style: TextStyle(
                                                    color: Color(0xFFfeb0ba),
                                                    fontSize: 16.0,)),
                                            SizedBox(
                                              height: 12.0,
                                            ),
                                            Text("\$ ${prodDoc.data["precio_pro"]}",
                                                style:
                                                    TextStyle(fontSize: 28.0, )),
                                          ],
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.shopping_cart),
                                          color: Colors.red,
                                          onPressed: () {
                                            _verProductDialog(context, prodDoc, widget.usu, widget.userDoc);
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )                       
                          )
                      ],
                    ),
                  );
              }
          );

        }
    );
  }
   Future<Null> _verProductDialog(BuildContext context, DocumentSnapshot prodDoc,
    FirebaseUser usu, DocumentSnapshot userDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('${prodDoc['nombre_pro']}'),
          content: Container(
            height: 320.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                SizedBox(                          
                        width: 250.0,
                        height: 150.0,
                        child: Image.network('${prodDoc['imagen_pro']}', width: 40),     
                ),//imagen               
               Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
                Text('${prodDoc['descripcion_pro']}'),
                Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
                Text('${prodDoc['precio_pro']}'),
               

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
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.blueGrey,
                  onPressed: (){ 
                    Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ConfirmarDireccionYPedido(userDoc: userDoc,
                                                catGenDoc: widget.catGenDoc, proveDoc: widget.proveDoc,
                                                catProvDoc: widget.catProvDoc, prodDoc: prodDoc,)
                        ));
                    
                      /* CloudFunctions.instance.call(
                        functionName: "crearPedidoUsu",
                        parameters: {
                          "doc_id": usu.uid,
                          "uid": prodDoc['uid'],
                          "nombre": prodDoc['nombre_pro'],
                          "descripcion": prodDoc['descripcion_pro'],
                          "precio": prodDoc['precio_pro'],
                          "imagen": prodDoc['imagen_pro'],
                        }
                      );
                      
                       CloudFunctions.instance.call(
                        functionName: "crearPedidoAdminBring",
                        parameters: {
                          "nombres": usu.displayName,
                          "correo": usu.email,
                          "telefono": userDoc.data['telefono'],
                          "nombrePizza": prodDoc['nombre_pro'],
                          "descripcion": prodDoc['descripcion_pro'],
                          "precio": prodDoc['precio_pro'],
                          "imagen": prodDoc['imagen_pro'],
                        }
                      );   *//* 
                      Navigator.of(context).pop();  */                     
                  }
                  ,)
              ],

        );
      }
    );
  }
}
