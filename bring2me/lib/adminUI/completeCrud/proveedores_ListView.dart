
import 'package:bring2me/adminUI/completeCrud/categoria_ListView.dart';
import 'package:bring2me/adminUI/completeCrud/crearProveedores_Admin.dart';
import 'package:bring2me/adminUI/menu_Admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                  return Dismissible( // <--------------------------NEW CODE-----------------
                    key: new Key(snapshot.data.documents[index].documentID),
                    
                    child: InkWell(
                       onTap:() { 
                         Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ListViewCategorias(ciu: widget.ciu, prove: provDoc,)
                                      ));                       
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
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () { /* _verProductoDialog(context, productDoc); */ }
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
  
/* 
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
                        functionName: "crearPedidoUsu",
                        parameters: {
                          "doc_id": widget.user.uid,
                          "uid": productDoc['uid'],
                          "nombre": productDoc['nombre_pro'],
                          "descripcion": productDoc['descripcion_pro'],
                          "precio": productDoc['precio_pro'],
                          "imagen": productDoc['imagen_pro'],
                        }
                      );
                      
                       CloudFunctions.instance.call(
                        functionName: "crearPedidoAdminBring",
                        parameters: {
                          "nombres": widget.user.displayName,
                          "correo": widget.user.email,
                          "telefono": userDoc.data['telefono'],
                          "nombrePizza": productDoc['nombre_pro'],
                          "descripcion": productDoc['descripcion_pro'],
                          "precio": productDoc['precio_pro'],
                          "imagen": productDoc['imagen_pro'],
                        }
                      ); 

                  },)
              ],
            );
          }
        );
        });
        

  }  */
}