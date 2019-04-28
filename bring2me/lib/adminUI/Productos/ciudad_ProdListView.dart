import 'package:bring2me/adminUI/Categoria/crearCategoria_Admin.dart';
import 'package:bring2me/adminUI/Ciudades/crearCiudad_Admin.dart';
import 'package:bring2me/adminUI/Productos/proveedor_ProdAdmin.dart';
import 'package:bring2me/adminUI/Proveedores/crearProveedores_Admin.dart';
import 'package:bring2me/adminUI/Proveedores/listaProveedores_Admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class ListViewProveedorProd extends StatefulWidget {
  @override
  _ListViewProveedorProdState createState() => new _ListViewProveedorProdState();
 }
class _ListViewProveedorProdState extends State<ListViewProveedorProd> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('SELECCIONE UNA CIUDAD:'),
      ),
      body: Center(
        
        child: _recuperarCiudades(),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearCiudad())),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), */ // This trailing comma makes auto-formatting nicer for build methods.
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
                         Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ListViewProveedoresParaProd(ciu: ciudadDoc)
                                      ));
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
                                 icon: Icon(Icons.edit, color: Colors.blue,),
                                     onPressed: (){
                                       
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
}

