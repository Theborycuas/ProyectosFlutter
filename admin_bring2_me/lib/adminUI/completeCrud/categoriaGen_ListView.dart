
import 'package:admin_bring2_me/adminUI/completeCrud/categoriaGen_CrearAdmin.dart';
import 'package:admin_bring2_me/adminUI/completeCrud/proveedores_ListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewCategoriasGen extends StatefulWidget {
  const ListViewCategoriasGen({Key key, @required this.ciu}) : super(key: key);  
  final DocumentSnapshot ciu;

  @override
  _ListViewCategoriasGenState createState() => new _ListViewCategoriasGenState();
 }
 
class _ListViewCategoriasGenState extends State<ListViewCategoriasGen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('CATEGORIAS GENERALES:'),       
      ),
      body: Center(
        child: _recuperarCategoriaS(),
      ),
       /* floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearCategoriaGen(ciu: widget.ciu))),
        tooltip: 'Crear Categoria',
        child: Icon(Icons.add),
      ),   */    
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarCategoriaS() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('categoriaGen').snapshots(),      
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

                  final catGenDoc = snapshot.data.documents[index];
                  return InkWell(
                       onTap:() { 
                         _verCategoriaDialog(context, catGenDoc, widget.ciu);
                       },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(catGenDoc['nombre_cat_gen']),
                                      subtitle: new Text(catGenDoc['descripcion_cat_gen']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${catGenDoc['imagen_cat_gen']}', width: 40),
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
                                              content: new Text("¿Realmente desea eliminar la categoria  ${catGenDoc.data['nombre_cat_gen']}?"),
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
                                                        Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('categoriaGen').document(catGenDoc.documentID).delete();        
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
                                       builder: (context) => ListViewProveedores(ciu: widget.ciu, catGen: catGenDoc,)
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

Future<Null> _verCategoriaDialog(BuildContext context, DocumentSnapshot catGenDoc,
   DocumentSnapshot ciuDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("${catGenDoc['nombre_cat']}"),
          content: Container(
            height: 400.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                Divider(height: 20,),
                Text("Descripción:"),
                Text("${catGenDoc['descripcion_cat']}", style: TextStyle(fontSize: 20.0),),
                Divider(height: 20,),
                SizedBox(height: 10,),
                Text("Imagen:"),
                SizedBox(height: 15,),
                FlatButton(
                  child: Image.network("${catGenDoc.data["imagen_cat"]}", width: 250.0,),
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
                  _actualizarCategoriaDialog(context, catGenDoc, widget.ciu);
                   
                },
                child: const Text("Actualizar")
            )
          ],

        );
      }
    );
  }

   Future<Null> _actualizarCategoriaDialog(BuildContext context, DocumentSnapshot catGenDoc,
    DocumentSnapshot ciuDoc) {
    TextEditingController _nombreController = new TextEditingController(text: catGenDoc['nombre_cat']);
    TextEditingController _descripcionController = new TextEditingController(text: catGenDoc['descripcion_cat']);
    TextEditingController _imagen = new TextEditingController(text: catGenDoc['imagen_cat']);

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
                  child: Image.network("${catGenDoc.data["imagen_cat"]}", width: 150.0,),
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
                      functionName: "actualizarCategoriaGeneral",
                      parameters: {
                        "doc_ciu": ciuDoc.documentID,
                        "doc_id": catGenDoc.documentID,
                        "nombre_cat_gen": _nombreController.text,
                        "descripcion_cat_gen": _descripcionController.text,
                        "imagen_cat_gen": _imagen.text
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