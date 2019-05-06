import 'package:bring2me/adminUI/completeCrud/crearCategoria_Admin.dart';
import 'package:bring2me/adminUI/completeCrud/productos_ListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewCategorias extends StatefulWidget {
  const ListViewCategorias({Key key, @required this.ciu, this.prove }) : super(key: key);  
  final DocumentSnapshot ciu;
  final DocumentSnapshot prove;

  @override
  _ListViewCategoriasState createState() => new _ListViewCategoriasState();
 }
 
class _ListViewCategoriasState extends State<ListViewCategorias> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('CATEGORIAS:'),       
      ),
      body: Center(
        child: _recuperarCategoriaS(),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearCategoria(ciu: widget.ciu, prov: widget.prove,))),
        tooltip: 'Crear Ciudad',
        child: Icon(Icons.add),
      ),      
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarCategoriaS() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('proveedor').document(widget.prove.documentID).collection('categoria').snapshots(),      
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            //print(logger);
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 285.0,),
                  Text('Cargando Categorias...'),
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

                  final catDoc = snapshot.data.documents[index];
                  return InkWell(
                       onTap:() { 
                         _verCategoriaDialog(context, catDoc, widget.ciu, widget.prove);
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
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: new Text("ELIMINAR LA CATEGORIA"),
                                              content: new Text("¿Realmente desea eliminar la categoria  ${catDoc.data['nombre_cat']}?"),
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
                                                        Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('proveedor').document(widget.prove.documentID).collection('categoria').document(catDoc.documentID).delete();        
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
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(
                                       builder: (context) => ListViewProductos(ciu: widget.ciu, prove: widget.prove, cat: catDoc,)
                                      ));
                                      },
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

Future<Null> _verCategoriaDialog(BuildContext context, DocumentSnapshot catDoc,
   DocumentSnapshot ciuDoc, DocumentSnapshot provDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("${catDoc['nombre_cat']}"),
          content: Container(
            height: 400.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                Divider(height: 20,),
                Text("Descripción:"),
                Text("${catDoc['descripcion_cat']}", style: TextStyle(fontSize: 20.0),),
                Divider(height: 20,),
                SizedBox(height: 10,),
                Text("Imagen:"),
                SizedBox(height: 15,),
                FlatButton(
                  child: Image.network("${catDoc.data["imagen_cat"]}", width: 250.0,),
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
                  _actualizarCategoriaDialog(context, catDoc, ciuDoc, provDoc);
                   
                },
                child: const Text("Actualizar")
            )
          ],

        );
      }
    );
  }

   Future<Null> _actualizarCategoriaDialog(BuildContext context, DocumentSnapshot catDoc,
    DocumentSnapshot ciuDoc, DocumentSnapshot provDoc) {
    TextEditingController _nombreController = new TextEditingController(text: catDoc['nombre_cat']);
    TextEditingController _descripcionController = new TextEditingController(text: catDoc['descripcion_cat']);
    TextEditingController _imagen = new TextEditingController(text: catDoc['imagen_cat']);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("EDITAR CATEGORIA"),
          content: Container(
            height: 420.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                new TextField(
                  controller: _nombreController,
                  decoration: new InputDecoration(labelText: "NombreCat: "),

                ),
                new TextField(
                  controller: _descripcionController,
                  decoration: new InputDecoration(labelText: "DescripcionCat: "),
                ),
                new TextField(
                  enabled: false,
                  controller: _imagen,
                  decoration: new InputDecoration(labelText: "ImagenCat: "),
                ),
                SizedBox(height: 10,),
                FlatButton(
                  child: Image.network("${catDoc.data["imagen_cat"]}", width: 150.0,),
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
            
            new FlatButton(
                onPressed: () {
                  CloudFunctions.instance.call(
                      functionName: "updateCategoria",
                      parameters: {
                        "doc_ciu": ciuDoc.documentID,
                        "doc_prov": provDoc.documentID,
                        "doc_id": catDoc.documentID,
                        "nombre_cat": _nombreController.text,
                        "descripcion_cat": _descripcionController.text,
                        "imagen_cat": _imagen.text
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