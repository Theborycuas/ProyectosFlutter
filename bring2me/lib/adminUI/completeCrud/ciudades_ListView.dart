import 'package:bring2me/adminUI/completeCrud/crearCiudad_Admin.dart';
import 'package:bring2me/adminUI/completeCrud/proveedores_ListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class ListViewCiudades extends StatefulWidget {
  @override
  _ListViewCiudadesState createState() => new _ListViewCiudadesState();
 }
class _ListViewCiudadesState extends State<ListViewCiudades> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('CIUDADES:'),
      ),
      body: Center(
        
        child: _recuperarCiudades(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearCiudad())),
        tooltip: 'Crear Ciudad',
        child: Icon(Icons.add),
      ),      
    );
  }
  
StreamBuilder<QuerySnapshot> _recuperarCiudades() {

    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            //print(logger);
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 285.0,),
                  Text('Cargando Ciudades...'),
                  SizedBox(height: 15.0,),
                  CupertinoActivityIndicator(            
                        ),
                ],
              ),
                
             );
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final ciudadDoc = snapshot.data.documents[index];

                  return InkWell(
                       onTap:() {
                         Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ListViewProveedores(ciu: ciudadDoc)
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

