
import 'package:bring2me/adminUI/completeCrud/categoria_ListView.dart';
import 'package:bring2me/adminUI/completeCrud/crearProveedores_Admin.dart';
import 'package:bring2me/adminUI/menu_Admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ListViewProveedores extends StatefulWidget {
  const ListViewProveedores({Key key, @required this.ciu }) : super(key: key);  
  final DocumentSnapshot ciu;

  @override
  _ListViewProveedoresState createState() => new _ListViewProveedoresState();
 }
 
class _ListViewProveedoresState extends State<ListViewProveedores> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(

        title: Text('PROVEEDORES:'),
        
      ),
      body: Center(
        child: _recuperarProveedores(),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearProveedor(prove: widget.ciu))),
        tooltip: 'Crear Ciudad',
        child: Icon(Icons.add),
      ),      
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarProveedores() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('proveedor').snapshots(),      
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            //print(logger);
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 285.0,),
                  Text('Cargando Proveedores...'),
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

                  final provDoc = snapshot.data.documents[index];
                  return InkWell(
                       onTap:() { 
                                  _verProveedorDialog(context, provDoc, widget.ciu);
                       },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(provDoc['nombre_prov']),
                                      subtitle: new Text(provDoc['direccion_prov']),
                                      
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
                                              title: new Text("ELIMINAR EL PROVEEDOR"),
                                              content: new Text("¿Realmente desea eliminar la categoria  ${provDoc.data['nombre_prov']}?"),
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
                                                        Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('proveedor').document(provDoc.documentID).delete();        
                                                        Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                        );
                                     }
                                    ),                                 
                                IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () { 
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ListViewCategorias(ciu: widget.ciu, prove: provDoc,)
                                              ));      
                                 }
                                )                            
                             ],
                             
                             
                           ),

                         ],
                         
                       )
                    
                  );
              }
          );

        }
    );

  }
  Future<Null> _verProveedorDialog(BuildContext context, DocumentSnapshot provDoc, DocumentSnapshot ciuDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("${provDoc['nombre_prov']}"),
          content: Container(
            height: 200.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                Divider(height: 20,),
                Text("Telefono:"),
                Text("${provDoc['telefono_prov']}", style: TextStyle(fontSize: 20.0),),
                Divider(height: 20,),
                Text("Dirección:"),
                Text("${provDoc['direccion_prov']}", style: TextStyle(fontSize: 20.0),),
                Divider(height: 20,),
                SizedBox(height: 10,),             
                

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
                  _actualizarProveedorDialog(context, provDoc, ciuDoc);
                   
                },
                child: const Text("Actualizar")
            )
          ],

        );
      }
    );
  }

   Future<Null> _actualizarProveedorDialog(BuildContext context, DocumentSnapshot provDoc, DocumentSnapshot ciuDoc) {
    TextEditingController _nombreController = new TextEditingController(text: provDoc['nombre_prov']);
    TextEditingController _telefono = new TextEditingController(text: provDoc['telefono_prov']);
    TextEditingController _direccion = new TextEditingController(text: provDoc['direccion_prov']);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("EDITAR EL PROVEEDOR"),
          content: Container(
            height: 420.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                new TextField(
                  controller: _nombreController,
                  decoration: new InputDecoration(labelText: "NombreProv: "),

                ),
                new TextField(
                  controller: _telefono,
                  decoration: new InputDecoration(labelText: "TelefonoProv: "),
                ),
                new TextField(
                  enabled: false,
                  controller: _direccion,
                  decoration: new InputDecoration(labelText: "DirecciónProv: "),
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
                      functionName: "updateProveedor",
                      parameters: {
                        "doc_ciu": ciuDoc.documentID,
                        "doc_id": provDoc.documentID,
                        "nombre_prov": _nombreController.text,
                        "direccion_prov": _direccion.text,
                        "telefono_prov": _telefono.text,
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