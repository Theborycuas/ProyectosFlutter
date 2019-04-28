import 'package:bring2me/adminUI/Categoria/crearCategoria_Admin.dart';
import 'package:bring2me/adminUI/Ciudades/crearCiudad_Admin.dart';
import 'package:bring2me/adminUI/Proveedores/crearProveedores_Admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class ListViewCiudad extends StatefulWidget {
  @override
  _ListViewCiudadState createState() => new _ListViewCiudadState();
 }
class _ListViewCiudadState extends State<ListViewCiudad> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('CIUDADES'),
      ),
      body: Center(
        child: _recuperarCiudades(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearCiudad())),
        tooltip: 'Crear Ciudad',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
StreamBuilder<QuerySnapshot> _recuperarCiudades() {

    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("No existen Ciudades creadas.");
            //print(logger);
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final ciudadDoc = snapshot.data.documents[index];

                  return Dismissible( // <--------------------------NEW CODE-----------------
                    key: new Key(snapshot.data.documents[index].documentID),
                    direction: DismissDirection.horizontal,
                    onDismissed: (DismissDirection direction) {
                      if (direction != DismissDirection.horizontal) {
                          Firestore.instance.collection('ciudad').document(ciudadDoc.documentID).delete();
                      }
                    },
                    child: InkWell(
                       onTap:() {
/*                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CrearProveedor(prov: ciudadDoc)
                                      )); */
                         },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(ciudadDoc['nombre_ciu']),
                                      subtitle: new Text(ciudadDoc['direccion_oficina']),                                     
                                 ),
                               ),
                               IconButton(
                                icon: Icon(Icons.delete, color: Colors.red,),
                                  onPressed: (){
                                    Firestore.instance.collection('categoria').document(ciudadDoc.documentID).delete();
                                  },
                                 ),
                               IconButton(
                                 icon: Icon(Icons.edit, color: Colors.blue,),
                                     onPressed: (){
                                       _actualizarCiudadDialog(context, ciudadDoc);
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
  Future<Null> _actualizarCiudadDialog(BuildContext context, DocumentSnapshot ciudadDoc) {
    TextEditingController _nombreController = new TextEditingController(text: ciudadDoc['nombre_ciu']);
    TextEditingController _direccion_oficina = new TextEditingController(text: ciudadDoc['direccion_oficina']);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("EDITAR CIUDAD"),
          content: Container(
            height: 420.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                new TextField(
                  enabled: false,
                  controller: _nombreController,
                  decoration: new InputDecoration(labelText: "NOMBRE: "),

                ),
                new TextField(
                  controller: _direccion_oficina,
                  decoration: new InputDecoration(labelText: "DIRECCION OFICINA: "),
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
                      functionName: "updateCiudad",
                      parameters: {
                        "doc_id": ciudadDoc.documentID,
                        "nombre_ciu": _nombreController.text,
                        "direccion_oficina": _direccion_oficina.text,
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

