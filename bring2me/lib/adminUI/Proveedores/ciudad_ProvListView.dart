import 'package:bring2me/adminUI/Ciudades/crearCiudad_Admin.dart';
import 'package:bring2me/adminUI/Proveedores/crearProveedores_Admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class ListViewProveedor extends StatefulWidget {
  @override
  _ListViewProveedorState createState() => new _ListViewProveedorState();
 }
class _ListViewProveedorState extends State<ListViewProveedor> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('CREAR UN PROVEEDOR EN:'),
      ),
      body: Center(
        
        child: _recuperarCiudadesParaProve(),
      ),
    );
  }
  
StreamBuilder<QuerySnapshot> _recuperarCiudadesParaProve() {

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

                  return InkWell(
                       onTap:() {
                         Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CrearProveedor(prove: ciudadDoc)
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
                    );
              }
          );

        }
    );
  }
}

