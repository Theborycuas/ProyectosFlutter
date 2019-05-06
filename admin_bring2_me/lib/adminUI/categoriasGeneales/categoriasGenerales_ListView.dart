import 'package:admin_bring2_me/adminUI/categoriasGeneales/crearCategorias_generales.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewCategoriasGeneales extends StatefulWidget {

  @override
  _ListViewCategoriasGenealesState createState() => new _ListViewCategoriasGenealesState();
 }
 
class _ListViewCategoriasGenealesState extends State<ListViewCategoriasGeneales> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('CATEGORIAS GENERALES:'),       
      ),
      body: Center(
        child: _recuperarCategoriasGenerales(),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CrearCategoriasGenerales())),
        tooltip: 'Crear Productos',
        child: Icon(Icons.add),
      ),      
    );
  }

   StreamBuilder<QuerySnapshot> _recuperarCategoriasGenerales() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categoriaGeneral').snapshots(),      
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
                                content: new Text("¿Realmente desea eliminar el prodcuto ${catGenDoc.data['nombre_cat_gen']}?"),
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
                                           Firestore.instance.collection('categoriaGeneral').document(catGenDoc.documentID).delete();        
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
                                              title: new Text("ELIMINAR PRODUCTO"),
                                              content: new Text("¿Realmente desea eliminar el prodcuto ${catGenDoc.data['nombre_cat_gen']}?"),
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
                                                        Firestore.instance.collection('categoriaGeneral').document(catGenDoc.documentID).delete();        
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