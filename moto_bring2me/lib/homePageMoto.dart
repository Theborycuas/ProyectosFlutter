import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageMoto extends StatefulWidget {
  HomePageMoto({Key key, @required this.docUsu}) : super(key: key);
  final DocumentSnapshot docUsu;

  _HomePageMotoState createState() => _HomePageMotoState();
}

class _HomePageMotoState extends State<HomePageMoto> {
  Color primaryColor = Colors.blueGrey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Pedidos"),  
      ),
      bottomNavigationBar: _contruccionBottomBar(),
      body: _recuperarPedios()

    );
  }
  
  StreamBuilder<QuerySnapshot> _recuperarPedios() {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('motoPedidos').snapshots(),      
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

                  final pedDoc = snapshot.data.documents[index];
                  return InkWell(
                       onTap:() { 
                           _verProductoDialog(context, pedDoc);
                       },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(pedDoc['nombre_cliente_pedido']),
                                      subtitle: new Text(pedDoc['fecha_hora_pedido']),
                                      leading: Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.location_on),
                                          onPressed: (){

                                          },
                                        )
                                      ],
                                    ),
                                 ),
                               ),      
                               IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.blueAccent,
                                  onPressed: (){
                                    /* _actualizarProductoDialog(context, prodDoc, widget.ciu, 
                                    widget.prove, widget.cat, widget.catGen); */
                                  },
                                ),
                                /* IconButton(
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
/*                                                         Firestore.instance.collection('ciudad').document(widget.ciu.documentID).collection('categoriaGen').document(widget.catGen.documentID).collection('proveedor').document(widget.prove.documentID).collection('categoria').document(widget.cat.documentID).collection('producto').document(prodDoc.documentID).delete();        
                                                        Navigator.of(context).pop();
 */                                                  },
                                                )
                                              ],
                                            );
                                          }
                                        );
                                 }
                                ), */
                                                         
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

  Future<Null> _verProductoDialog(BuildContext context, DocumentSnapshot prodDoc) {

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
                  /*  _actualizarProductoDialog(context, prodDoc, ciuDoc, provDoc, catDoc, catGen); */
                },
                child: const Text("Actualizar")
            )
          ],

        );
      }
    );
  }

  Widget _contruccionBottomBar() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.home,
              size: 35,
              color: primaryColor,
            ),
            Icon(
              Icons.list,
              color: Colors.black54,
              size: 30,
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              iconSize: 30.0,
              onPressed: (){
              /*   Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ListViewPrePedidos(docUsu: widget.docUsu,)
                    )); */
              },
            ),
           
            IconButton(
              icon: Icon(Icons.perm_identity, 
                size: 30.0,),
                onPressed: (){
                 /*  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => UserProfile(usuDoc: widget.docUsu, user: widget.usu,)
                    )); */
                },              
            ),
          ],
        ),
      ),
    );
  }
}