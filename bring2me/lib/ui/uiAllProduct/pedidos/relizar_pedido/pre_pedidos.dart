import 'package:bring2me/ui/uiAllProduct/pedidos/relizar_pedido/confirmar_pedido.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewPrePedidos extends StatefulWidget {
  const ListViewPrePedidos({Key key, @required this.docUsu}) : super(key: key);
  final DocumentSnapshot docUsu;

  @override
  _ListViewPrePedidosState createState() => new _ListViewPrePedidosState();
}

class _ListViewPrePedidosState extends State<ListViewPrePedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CARRITO DE PEDIDOS:'),
      ),
      body: Center(
        child: _recuperarPrePedidos(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConfirmarDireccionYPedido(
                        userDoc: widget.docUsu,
                      )));
        },
        tooltip: 'Realizar pedido',
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> _recuperarPrePedidos() {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('usuarios')
            .document(widget.docUsu.documentID)
            .collection('prePedidosUsu')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            //print(logger);
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 285.0,
                  ),
                  Text('Cargando Productos...'),
                  SizedBox(
                    height: 15.0,
                  ),
                  CupertinoActivityIndicator(),
                ],
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                final prePedDoc = snapshot.data.documents[index];
                TextEditingController _cantidad =
                    TextEditingController(text: prePedDoc['cantidad_pro']);
                return InkWell(
                    onTap: () {
                      _verProductoDialog(context, prePedDoc);
                    },
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: new Text(prePedDoc['nombre_pro']),
                                subtitle:
                                    new Text(prePedDoc['descripcion_pro']),
                                leading: Column(
                                  children: <Widget>[
                                    Image.network('${prePedDoc['imagen_pro']}',
                                        width: 40),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50.0,
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: _cantidad,
                                    decoration:
                                        InputDecoration(labelText: "Cant."),
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: new Text("ELIMINAR PRODUCTO"),
                                          content: new Text(
                                              "¿Realmente desea eliminar el prodcuto ${prePedDoc.data['nombre_pro']}?"),
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
                                              onPressed: () {
                                                Firestore.instance
                                                    .collection('usuarios')
                                                    .document(widget
                                                        .docUsu.documentID)
                                                    .collection('prePedidosUsu')
                                                    .document(
                                                        prePedDoc.documentID)
                                                    .delete();
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }),
                          ],
                        ),
                      ],
                    ));
              });
        });
  }

  Future<Null> _verProductoDialog(
      BuildContext context, DocumentSnapshot prePedDoc) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("${prePedDoc['nombre_pro']}"),
            content: Container(
              height: 400.0,
              width: 100.0,
              child: ListView(
                children: <Widget>[
                  Divider(
                    height: 20,
                  ),
                  Text("Descripción:"),
                  Text(
                    "${prePedDoc['descripcion_pro']}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Text("Precio:"),
                  Text("\$${prePedDoc['precio_pro']}",
                      style: TextStyle(fontSize: 20.0)),
                  Divider(
                    height: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Imagen:"),
                  SizedBox(
                    height: 15,
                  ),
                  FlatButton(
                    child: Image.network(
                      "${prePedDoc.data["imagen_pro"]}",
                      width: 250.0,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar")),
              // This button results in adding the contact to the database
              new FlatButton(onPressed: () {}, child: const Text("Actualizar"))
            ],
          );
        });
  }
}
