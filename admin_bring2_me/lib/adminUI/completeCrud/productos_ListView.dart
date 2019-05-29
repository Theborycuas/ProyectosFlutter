import 'package:admin_bring2_me/adminUI/completeCrud/productos_CrearAdmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewProductos extends StatefulWidget {
  const ListViewProductos({Key key, @required this.ciu, this.catGen, this.prove, this.cat }) : super(key: key);  
  final DocumentSnapshot ciu;  
  final DocumentSnapshot catGen;
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
          builder: (context)=>CrearProducto(ciu: widget.ciu, catGen: widget.catGen, prove: widget.prove, cat: widget.cat,))),
        tooltip: 'Crear Productos',
        child: Icon(Icons.add),
      ),      
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarProductos() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('categoriaGen').document(widget.catGen.documentID).collection('proveedor').document(widget.prove.documentID).collection('categoria').document(widget.cat.documentID).collection('productos').snapshots(),      
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
                  return InkWell(
                       onTap:() { 
                           _verProductoDialog(context, prodDoc, widget.ciu, widget.prove, 
                                              widget.cat, widget.catGen);
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
                                  icon: Icon(Icons.edit),
                                  color: Colors.blueAccent,
                                  onPressed: (){
                                    _actualizarProductoDialog(context, prodDoc, widget.ciu, 
                                    widget.prove, widget.cat, widget.catGen);
                                  },
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
                                                        Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('categoriaGen').document(widget.catGen.documentID).collection('proveedor').document(widget.prove.documentID).collection('categoria').document(widget.cat.documentID).collection('producto').document(prodDoc.documentID).delete();        
                                                        Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          }
                                        );
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

  Future<Null> _verProductoDialog(BuildContext context, DocumentSnapshot prodDoc,
   DocumentSnapshot ciuDoc, DocumentSnapshot provDoc, DocumentSnapshot catDoc, DocumentSnapshot catGen) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("${prodDoc['nombre_pro']}"),
          content: Container(
            height: 400.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                Divider(height: 20,),
                Text("Descripción:"),
                Text("${prodDoc['descripcion_pro']}", style: TextStyle(fontSize: 20.0),),
                Divider(height: 20,),
                Text("Precio:"),
                Text("\$${prodDoc['precio_pro']}", style: TextStyle(fontSize: 20.0)),
                Divider(height: 20,),
                SizedBox(height: 10,),
                Text("Imagen:"),
                SizedBox(height: 15,),
                FlatButton(
                  child: Image.network("${prodDoc.data["imagen_pro"]}", width: 250.0,),
                  onPressed: (){},
                )
                

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
                   _actualizarProductoDialog(context, prodDoc, ciuDoc, provDoc, catDoc, catGen);
                },
                child: const Text("Actualizar")
            )
          ],

        );
      }
    );
  }

   Future<Null> _actualizarProductoDialog(BuildContext context, DocumentSnapshot prodDoc,
   DocumentSnapshot ciuDoc, DocumentSnapshot provDoc, DocumentSnapshot catDoc, DocumentSnapshot catgen) {
    TextEditingController _nombreController = new TextEditingController(text: prodDoc['nombre_pro']);
    TextEditingController _descripcionController = new TextEditingController(text: prodDoc['descripcion_pro']);
    TextEditingController _precioControlles = new TextEditingController(text: prodDoc['precio_pro']);
    TextEditingController _imagen = new TextEditingController(text: prodDoc['imagen_pro']);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("EDITAR PRODUCTO"),
          content: Container(
            height: 420.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                new TextField(
                  controller: _nombreController,
                  decoration: new InputDecoration(labelText: "NombrePro: "),

                ),
                new TextField(
                  controller: _descripcionController,
                  decoration: new InputDecoration(labelText: "DescripcionPro: "),
                ),
                new TextField(
                  controller: _precioControlles,
                  decoration: new InputDecoration(labelText: "PrecioPro: "),

                ),
                new TextField(
                  enabled: false,
                  controller: _imagen,
                  decoration: new InputDecoration(labelText: "ImagenPro: "),
                ),
                SizedBox(height: 10,),
                FlatButton(
                  child: Image.network("${prodDoc.data["imagen_pro"]}", width: 150.0,),
                  onPressed: (){},
                )
                

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
                  CloudFunctions.instance.call(
                      functionName: "updateProducto",
                      parameters: {
                        "doc_ciu": ciuDoc.documentID,
                        "doc_prov": provDoc.documentID,
                        "doc_cat": catDoc.documentID,
                        "doc_id": prodDoc.documentID,
                        "nombre_pro": _nombreController.text,
                        "descripcion_pro": _descripcionController.text,
                        "precio_pro": _precioControlles.text,
                        "imagen_pro": _imagen.text
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