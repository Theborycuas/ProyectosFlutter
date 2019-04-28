import 'package:bring2me/adminUI/Categoria/crearCategoria_Admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class ListViewCategoria extends StatefulWidget {
  @override
  _ListViewCategoriaState createState() => new _ListViewCategoriaState();
 }
class _ListViewCategoriaState extends State<ListViewCategoria> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('CATEGORIAS'),
      ),
      body: Center(
        child: _recuperarCategorias(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearCategoria(ciu: null, prov: null,))),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
StreamBuilder<QuerySnapshot> _recuperarCategorias() {

    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categoria').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("No existen Categorias creadas.");
            //print(logger);
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final categoriaDoc = snapshot.data.documents[index];

                  return Dismissible( // <--------------------------NEW CODE-----------------
                    key: new Key(snapshot.data.documents[index].documentID),
                    direction: DismissDirection.horizontal,
                    onDismissed: (DismissDirection direction) {
                      if (direction != DismissDirection.horizontal) {
                          Firestore.instance.collection('categoria').document(categoriaDoc.documentID).delete();
                      }
                    },
                    child: InkWell(
                       onTap:() {
                         _recuperarPedidos(categoriaDoc);
                         },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(categoriaDoc['nombre_cat']),
                                      subtitle: new Text(categoriaDoc['descripcion_cat']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${categoriaDoc['imagen_cat']}', width: 40),
                                      ],
                                    ),
                                 ),
                               ),
                               IconButton(
                                icon: Icon(Icons.delete, color: Colors.red,),
                                  onPressed: (){
                                    Firestore.instance.collection('categoria').document(categoriaDoc.documentID).delete();
                                  },
                                 ),
                               IconButton(
                                 icon: Icon(Icons.edit, color: Colors.blue,),
                                     onPressed: (){
                                       _actualizarCategoriaDialog(context, categoriaDoc);
                                     },
                                  )
                               
                             ],
                             
                           )
                         ],
                       )
                    )
                  );
              }
          );

        }
    );
  }
Future<Null> _recuperarPedidos(DocumentSnapshot categoriaDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
           title: Text('PRODUCTOS'),
          content: Container(
            
            height: 820.0,
            width: 500.0,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('categoria').document(categoriaDoc.documentID).collection('producto').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    print("No existen Categorias creadas.");
                    //print(logger);
                    return Container();
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {

                          final productoDoc = snapshot.data.documents[index];

                          return InkWell(
                              onTap:() {
                                _verCategoriaDialog(context, productoDoc);
                                },
                                child:
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ListTile(
                                              title: new Text(productoDoc['nombre_pro']),
                                              subtitle: new Text(productoDoc['descripcion_pro']),
                                              leading: Column(
                                              children: <Widget>[
                                                Image.network('${productoDoc['imagen_pro']}', width: 10),
                                              ],
                                            ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red,),
                                          onPressed: (){
                                            Firestore.instance.collection('categoria').document(categoriaDoc.documentID).collection('producto').document(productoDoc.documentID).delete();
                                          },
                                        ),
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue,),
                                            onPressed: (){
                                              _actualizarCategoriaDialog(context, productoDoc);
                                            },
                                          )
                                      
                                    ],
                                    
                                  )
                            );
                      }
                  );

                }
            ),
          ),

        );
      }
    );
  }
  Future<Null> _actualizarCategoriaDialog(BuildContext context, DocumentSnapshot categoriaDoc) {
    TextEditingController _nombreController = new TextEditingController(text: categoriaDoc['nombre']);
    TextEditingController _descripcionController = new TextEditingController(text: categoriaDoc['descripcion']);
    TextEditingController _imagen = new TextEditingController(text: categoriaDoc['imagen']);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("EDITAR CATEGORIA"),
          content: Container(
            height: 420.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                new TextField(
                  controller: _nombreController,
                  decoration: new InputDecoration(labelText: "Nombre: "),

                ),
                new TextField(
                  controller: _descripcionController,
                  decoration: new InputDecoration(labelText: "Descripcion: "),
                ),                
                new TextField(
                  controller: _imagen,
                  decoration: new InputDecoration(labelText: "Imagen: "),
                ),

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
            // This button results in adding the contact to the database
            new FlatButton(
                onPressed: () {
                  CloudFunctions.instance.call(
                      functionName: "updateCategoria",
                      parameters: {
                        "doc_id": categoriaDoc.documentID,
                        "nombre": _nombreController.text,
                        "descripcion": _descripcionController.text,
                        "imagen": _imagen.text
                      }
                  );
                  Navigator.of(context).pop();
                },
                child: const Text("Guardar")
            )
          ],

        );
      }
    );
  }
  
  Future<Null> _verCategoriaDialog(BuildContext context, DocumentSnapshot categoriaDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('${categoriaDoc['nombre']}'),
          content: Container(
            height: 320.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                SizedBox(                          
                        width: 250.0,
                        height: 150.0,
                        child: Image.network('${categoriaDoc['imagen']}', width: 40),     
                ),//imagen               
               Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
                Text('${categoriaDoc['descripcion']}'),
                Padding(padding: EdgeInsets.only(top: 15.0),),
                             

              ],
            ),
          ),
          actions: <Widget>[
             new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK")
            )
          ],

        );
      }
    );
  }
}

