import 'package:admin_bring2_me/adminUI/completeCrud/categoriaGen_ListView.dart';
import 'package:admin_bring2_me/adminUI/completeCrud/ciudad_CrearAdmin.dart';
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
                         _verCategoriaDialog(context, ciudadDoc);
                        
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
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: new Text("ELIMINAR LA CIUDAD"),
                                              content: new Text("¿Realmente desea eliminar la ciudad  ${ciudadDoc.data['nombre_ciu']}?"),
                                              actions: <Widget>[
                                                // usually buttons at the bottom of the dialog
                                                new FlatButton(
                                                  child: new Text("CANCELAR"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text("ACEPTAR"),
                                                  onPressed: (){
                                                       /*  Firestore.instance.collection('ciudad').document(ciudadDoc.documentID).delete();        
                                                        Navigator.of(context).pop(); */
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                        );
                                     }
                                    ), 
                               IconButton(
                                 icon: Icon(Icons.arrow_forward, color: Colors.blue,),
                                     onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => ListViewCategoriasGen(ciu: ciudadDoc)
                                                    ));
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
  
Future<Null> _verCategoriaDialog(BuildContext context, DocumentSnapshot ciuDoc,) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("${ciuDoc['nombre_ciu']}"),
          content: Container(
            height: 400.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                Divider(height: 20,),
                Text("Dirección Oficina:"),
                Text("${ciuDoc['direccion_oficina']}", style: TextStyle(fontSize: 20.0),),
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
                  _actualizarCategoriaDialog(context, ciuDoc);
                   
                },
                child: const Text("Actualizar")
            )
          ],

        );
      }
    );
  }

   Future<Null> _actualizarCategoriaDialog(BuildContext context, DocumentSnapshot ciuDoc) {
    TextEditingController _nombreController = new TextEditingController(text: ciuDoc['nombre_ciu']);
    TextEditingController _descripcionController = new TextEditingController(text: ciuDoc['direccion_oficina']);

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
                  controller: _nombreController,
                  decoration: new InputDecoration(labelText: "NombreCiu: "),

                ),
                new TextField(
                  controller: _descripcionController,
                  decoration: new InputDecoration(labelText: "DireccionOficina: "),
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
            
            new FlatButton(
                onPressed: () {
                  CloudFunctions.instance.call(
                      functionName: "updateCiudad",
                      parameters: {
                        "doc_id": ciuDoc.documentID,
                        "nombre_ciu": _nombreController.text,
                        "direccion_oficina": _descripcionController.text,
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
}

