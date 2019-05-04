import 'package:bring2me/adminUI/completeCrud/crearCategoria_Admin.dart';
import 'package:bring2me/adminUI/completeCrud/crearProductos_Admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewProductos extends StatefulWidget {
  const ListViewProductos({Key key, @required this.ciu, this.prove, this.cat }) : super(key: key);  
  final DocumentSnapshot ciu;
  final DocumentSnapshot prove;
  final DocumentSnapshot cat;

  @override
  _ListViewProductosState createState() => new _ListViewProductosState();
 }
 
class _ListViewProductosState extends State<ListViewProductos> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('PRODUCTOS:'),       
      ),
      body: Center(
        child: _recuperarProductos(),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearProducto(ciu: widget.ciu, prove: widget.prove, cat: widget.cat,))),
        tooltip: 'Crear Productos',
        child: Icon(Icons.add),
      ),      
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarProductos() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('proveedor').document(widget.prove.documentID).collection('categoria').document(widget.cat.documentID).collection('producto').snapshots(),      
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            //print(logger);
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 285.0,),
                  Text('Cargando Productos...'),
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

                  final prodDoc = snapshot.data.documents[index];
                  return Dismissible( // <--------------------------NEW CODE-----------------
                    key: new Key(snapshot.data.documents[index].documentID),
                    direction: DismissDirection.horizontal,
                    onDismissed: (DismissDirection direction) {
                      if (direction != DismissDirection.horizontal) {
                          
                          showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: new Text("ELIMINAR PRODUCTO"),
                                content: new Text("¿Realmente desea eliminar el prodcuto ${prodDoc.data['nombre_pro']}?"),
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
                                           Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('proveedor').document(widget.prove.documentID).collection('categoria').document(widget.cat.documentID).collection('producto').document(prodDoc.documentID).delete();        
                                           Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            }
                          );
                         
                      }
                    },                    
                    
                    child: InkWell(
                       onTap:() { 
                           /* Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CrearProducto(cat:widget.cat, prove: widget.prove, ciu: widget.ciu,)
                                      ));  */
                       },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(prodDoc['nombre_pro']),
                                      subtitle: new Text(prodDoc['descripcion_pro']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${prodDoc['imagen_pro']}', width: 40),
                                      ],
                                    ),
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
                                              title: new Text("ELIMINAR PRODUCTO"),
                                              content: new Text("¿Realmente desea eliminar el prodcuto ${prodDoc.data['nombre_pro']}?"),
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
                                                        Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('proveedor').document(widget.prove.documentID).collection('categoria').document(widget.cat.documentID).collection('producto').document(prodDoc.documentID).delete();        
                                                        Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          }
                                        );
                                 }
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