import 'package:bring2me/adminUI/completeCrud/crearCategoria_Admin.dart';
import 'package:bring2me/adminUI/completeCrud/productos_ListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                  return Dismissible( // <--------------------------NEW CODE-----------------
                    key: new Key(snapshot.data.documents[index].documentID),
                    
                    child: InkWell(
                       onTap:() { 
                         Navigator.push(context, MaterialPageRoute(
                                       builder: (context) => ListViewProductos(ciu: widget.ciu, prove: widget.prove, cat: catDoc,)
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
                                onPressed: () {
                                  
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