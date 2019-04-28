import 'package:bring2me/adminUI/Productos/categoria_ProdListAdmin..dart';
import 'package:bring2me/login/signin_google_perfil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ListViewProveedoresParaProd extends StatefulWidget {
  const ListViewProveedoresParaProd({Key key, @required this.ciu }) : super(key: key);  
  final DocumentSnapshot ciu;

  @override
  _ListViewProveedoresParaProdState createState() => new _ListViewProveedoresParaProdState();
 }
 
class _ListViewProveedoresParaProdState extends State<ListViewProveedoresParaProd> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(

        title: Text('SELECCIONE UN PROVEEDOR'),
        
      ),
      body: Center(
        child: _recuperarProveedorParaProducto(),
      ),
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarProveedorParaProducto() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('proveedor').snapshots(),      
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("No existen Proveedores creados.");
            //print(logger);
            return Container();
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
                              builder: (context) => ListViewCategoriaParaProd(prove: provDoc, ciu: widget.ciu,)
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
  
}