import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewPedidos extends StatefulWidget {


  @override
  _ListViewPedidosState createState() => new _ListViewPedidosState();
 }
 
class _ListViewPedidosState extends State<ListViewPedidos> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('PEDIDOS:'),       
      ),
      body: Center(
        child: _recuperarPedidos(),
      ),
       /* floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearProducto(ciu: widget.ciu, catGen: widget.catGen, prove: widget.prove, cat: widget.cat,))),
        tooltip: 'Crear Productos',
        child: Icon(Icons.add),
      ),    */   
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarPedidos() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('pedidoAdmin').snapshots(),      
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
                           _verProductoDialog(context, prodDoc); 
                       },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(prodDoc['nombrePizza']),
                                      subtitle: new Text(prodDoc['nombres']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${prodDoc['imagen']}', width: 40),
                                      ],
                                    ),
                                 ),
                               ),      
                               IconButton(
                                  icon: Icon(Icons.more_vert),
                                  color: Colors.blueAccent,
                                  onPressed: (){
                                    _verProductoDialog(context, prodDoc); 
                                  },
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

  Future<Null> _verProductoDialog(BuildContext context, DocumentSnapshot prodDoc,) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("${prodDoc['nombrePizza']}"),
          content: Container(
            height: 400.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                Divider(height: 20,),
                Text("Descripción:"),
                Text("${prodDoc['descripcion']}", style: TextStyle(fontSize: 20.0),),
                Divider(height: 20,),
                Text("Precio:"),
                Text("\$${prodDoc['precio']}", style: TextStyle(fontSize: 20.0)),
                Divider(height: 20,),
                SizedBox(height: 10,),
                Text("Imagen:"),
                SizedBox(height: 15,),
                FlatButton(
                  child: Image.network("${prodDoc.data["imagen"]}", width: 250.0,),
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
                   _actualizarProductoDialog(context, prodDoc);
                },
                child: const Text("DESPACHADO")
            )
          ],

        );
      }
    );
  }

   Future<Null> _actualizarProductoDialog(BuildContext context, DocumentSnapshot prodDoc) {
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