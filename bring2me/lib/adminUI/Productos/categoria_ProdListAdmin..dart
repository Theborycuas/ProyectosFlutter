import 'package:bring2me/adminUI/Productos/crearProductos_Admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListViewCategoriaParaProd extends StatefulWidget {
  const ListViewCategoriaParaProd({Key key, @required this.ciu, this.prove }) : super(key: key);  
  final DocumentSnapshot ciu;
  final DocumentSnapshot prove;

  @override
  _ListViewCategoriaParaProdState createState() => new _ListViewCategoriaParaProdState();
 }
 
class _ListViewCategoriaParaProdState extends State<ListViewCategoriaParaProd> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('SELECCIONE UNA CATEGORIA'),       
      ),
      body: Center(
        child: _recuperarCategoriaParaProductos(),
      ),
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarCategoriaParaProductos() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('proveedor').document(widget.prove.documentID).collection('categoria').snapshots(),      
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("No existen Proveedores creados.");
            //print(logger);
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final catDoc = snapshot.data.documents[index];
                  return Dismissible( // <--------------------------NEW CODE-----------------
                    key: new Key(snapshot.data.documents[index].documentID),
                    
                    child: InkWell(
                       onTap:() { 
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CrearProducto(cat:catDoc, prove: widget.prove, ciu: widget.ciu,)
                                      ));
                       },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(catDoc['nombre_cat']),
                                      subtitle: new Text(catDoc['descripcion_cat']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${catDoc['imagen_cat']}', width: 40),
                                      ],
                                    ),
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