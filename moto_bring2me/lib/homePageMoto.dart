import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moto_bring2me/listaProductos.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
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
                                  icon: Icon(Icons.list),
                                  color: Colors.blueAccent,
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ListaProductosMoto(docUsu: widget.docUsu, docPed: pedDoc,) 
                                    )); 
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

  Future<Null> _verProductoDialog(BuildContext context, DocumentSnapshot prodDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("${prodDoc['nombre_cliente_pedido']}"),
          content: Container(
            height: 300.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                Text("Fecha y Hora de Pedido:"),
                Text("${prodDoc['fecha_hora_pedido']}", style: TextStyle(fontSize: 20.0)),
                Divider(height: 20,),
                Text("Direccion:"),
                Text("${prodDoc['direccion_cliente_pedido']}", style: TextStyle(fontSize: 20.0),),
                Divider(height: 20,),
                Text("Telefono:"),
                Text("${prodDoc['telefono_cliente_pedido']}", style: TextStyle(fontSize: 20.0),),
                Divider(height: 20,),                
                Text("Precio:"),
                Text("${prodDoc['estado_pedido']}", style: TextStyle(fontSize: 20.0)),
                                             
                

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
                   Navigator.push(context, MaterialPageRoute(
                             builder: (context) => ListaProductosMoto(docUsu: widget.docUsu, docPed: prodDoc,) 
                   )); 
                   
                },
                child: const Text("Lista")
            ),
            new FlatButton(
                onPressed: () {
                  /*  _actualizarProductoDialog(context, prodDoc, ciuDoc, provDoc, catDoc, catGen); */
                },
                child: const Text("ACEPTAR PEDI")
            ),
            
          ],

        );
      }
    );
  }
/* 
void _aceptarPedido(DocumentSnapshot docUsu)  {
      DateTime now = DateTime.now();              
      String formattedDate = DateFormat('dd-MM-yyyy hh:mm a').format(now);
      String fechaHoraPed = DateFormat('dd-MM-yyyy hh:mm:ss').format(now);
      String estadoPedido = "Esperando Motociclista";
              
                CloudFunctions.instance.call(
                    functionName: "crearNumeroPedido",
                    parameters: {
                      "doc_id": widget.userDoc.documentID,
                      "numero_pedido" : formattedDate.toString(),
                      "fecha_hora_pedido": fechaHoraPed.toString()
                    }
                );
                 CloudFunctions.instance.call(
                    functionName: "crearPedidoMoto",
                    parameters: {
                    "titulo_pedido": formattedDate.toString(),
                    "nombre_cliente_pedido": widget.userDoc.data["nombres"],
                    "direccion_cliente_pedido": widget.userDoc.data["direccion"],
                    "telefono_cliente_pedido": widget.userDoc.data["telefono"],
                    "correo_cliente_pedido": widget.userDoc.data["correo"],
                    "fecha_hora_pedido": fechaHoraPed.toString(),
                    "estado_pedido": estadoPedido.toString()
                    }
                );
                Firestore.instance.collection('usuarios')
                .document(widget.userDoc.documentID)
                .collection('prePedidosUsu')
                .getDocuments().then((snapshot){
                  /* final cont = snapshot.documents.length; */

                  for (DocumentSnapshot docPrepeConfir in snapshot.documents){
                     CloudFunctions.instance.call(
                      functionName: "crearPedidoUsu",
                      parameters: {
                        "doc_id": widget.userDoc.documentID,
                        "doc_numeroPedido" : formattedDate.toString(),
                        "nombre_pro": docPrepeConfir['nombre_pro'],
                        "descripcion_pro": docPrepeConfir['descripcion_pro'],
                        "precio_pro": docPrepeConfir['precio_pro'],
                        "imagen_pro": docPrepeConfir['imagen_pro'],
                        "cantidad_pro": docPrepeConfir['cantidad_pro'],
                              }
                      );
                    CloudFunctions.instance.call(
                      functionName: "crearProductoPedidoMoto",
                      parameters: {
                        "id_pedido": formattedDate.toString(),
                        "nombre_pro": docPrepeConfir['nombre_pro'],
                        "descripcion_pro": docPrepeConfir['descripcion_pro'],
                        "precio_pro": docPrepeConfir['precio_pro'],
                        "imagen_pro": docPrepeConfir['imagen_pro'],
                        "cantidad_pro": docPrepeConfir['cantidad_pro'],
                      }
                    );
                   }
                }); 
                Firestore.instance.collection('usuarios')
                .document(widget.userDoc.documentID)
                .collection('prePedidosUsu')
                .getDocuments().then((snapshot){
                  for (DocumentSnapshot docPrepeDel in snapshot.documents){
                      docPrepeDel.reference.delete();
                   }
                });  
                print('Completed, check fields.');
                showToast("Completed, check fields.", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProductHomePage(usu: widget.usu, )
                ));       

}
 */
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
  void showToast(String msg, BuildContext context,
      {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}