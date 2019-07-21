import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:toast/toast.dart';

class ListViewPedidosEnProceso extends StatefulWidget {
 const ListViewPedidosEnProceso({Key key, @required this.docUsu}) : super(key:key);

 final DocumentSnapshot docUsu;

  @override
  _ListViewPedidosEnProcesoState createState() => new _ListViewPedidosEnProcesoState();
 }
 
class _ListViewPedidosEnProcesoState extends State<ListViewPedidosEnProceso> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(

        title: Text('Pedidos en Proceso:'),
        
      ),
      body: Center(
        child: _recuperarPedidoEnProc(),
      ),
       
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarPedidoEnProc() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('usuarios').document(widget.docUsu.documentID).collection('pedidosProcUsu').snapshots(),      
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

                  final numpedDoc = snapshot.data.documents[index];
                  return InkWell(
                       onTap:() { 
                                  /* _verProveedorDialog(context, provDoc, widget.ciu, widget.catGen); */
                       },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(numpedDoc['numero_pedido']),
                                      
                                      
                                 ),
                               ),  
                                IconButton(
                                icon: Icon(Icons.info),
                                color: Colors.blueAccent,
                                onPressed: () {
                                }
                                    ),                                 
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
  Future<Null> _verProveedorDialog(BuildContext context, DocumentSnapshot provDoc, DocumentSnapshot ciuDoc, DocumentSnapshot catGen) {

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
                  _actualizarProveedorDialog(context, provDoc, ciuDoc, catGen);
                   
                },
                child: const Text("Actualizar")
            )
          ],

        );
      }
    );
  }

   Future<Null> _actualizarProveedorDialog(BuildContext context, DocumentSnapshot provDoc,
    DocumentSnapshot ciuDoc, DocumentSnapshot catGen) {
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
                        "doc_catGen": catGen.documentID,
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
 void showToast(String msg, BuildContext context,
      {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  
}