import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class AdminPedidos extends StatefulWidget {
  @override
  _AdminPedidosState createState() => new _AdminPedidosState();
 }
class _AdminPedidosState extends State<AdminPedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('PIZZAS'),
      ),
      body: Center(
        child: _recuperarPedidos(),
      ),
    );
  }
  StreamBuilder<QuerySnapshot> _recuperarPedidos() {

    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('pedidoAdmin').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("No existen Pizzas creadas.");
            //print(logger);
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final pedidosDoc = snapshot.data.documents[index];
                  return Dismissible(
                    key: new Key(snapshot.data.documents[index].documentID),
/*                     direction: DismissDirection.horizontal,
                    onDismissed: (DismissDirection direction) {
                      if (direction != DismissDirection.horizontal) {
                          Firestore.instance.collection('pizzas').document(pedidosDoc.documentID).delete();
                      }
                    }, */
                    child: InkWell(
                       onTap:() {_verPizzaDialog(context, pedidosDoc);},
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(pedidosDoc['nombres']),
                                      subtitle: new Text(pedidosDoc['nombrePizza']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${pedidosDoc['imagen']}', width: 40),
                                      ],
                                    ),
                                 ),
                               ),
                               IconButton(
                                icon: Icon(Icons.eject, color: Colors.red,),
                                  onPressed: (){
                                    
                                  },
                                 ),

                               
                             ],
                             
                           )
                         ],
                       )
                    )
                  );
              }
          );

        }
    );
  }
   Future<Null> _verPizzaDialog(BuildContext context, DocumentSnapshot pizzaDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('${pizzaDoc['nombre']}'),
          content: Container(
            height: 320.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                SizedBox(                          
                        width: 250.0,
                        height: 150.0,
                        child: Image.network('${pizzaDoc['imagen']}', width: 40),     
                ),//imagen               
               Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
                Text('${pizzaDoc['descripcion']}'),
                Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
                Text('${pizzaDoc['precio']}'),
               

              ],
            ),
          ),
          actions: <Widget>[
             new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK")
            )
          ],

        );
      }
    );
  }
}


/* 
class AdminPedidos extends StatefulWidget {
  @override
  _AdminPedidosState createState() => new _AdminPedidosState();
 }
 final productReference = FirebaseDatabase.instance.reference().child('pedidospizzas');

class _AdminPedidosState extends State<AdminPedidos> {
List<PedidosPizzas> items;
  StreamSubscription<Event> _onProductAddSubscription;
  StreamSubscription<Event> _onProductChangedSubscription;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = List();
    _onProductAddSubscription = productReference.onChildAdded.listen(_onProductAdd);
    _onProductChangedSubscription =productReference.onChildChanged.listen(_onProductUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onProductAddSubscription.cancel();
    _onProductChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
   return new Scaffold(
       appBar: AppBar( 
         title: Text("PEDIDOS"),         
         backgroundColor: Colors.green,
         actions: <Widget>[
           new IconButton(
             icon: new Icon(Icons.close),
            onPressed: () => Navigator.push(context, 
                   MaterialPageRoute(builder: (context) => Menu())),
           ),
         ],
         
       ),
       body: 
       Center(
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.only(top: 12.0),
            itemBuilder: (context, position){
              return Column(
                children: <Widget>[
                  Divider(height: 20.0,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(title: Text('${items[position].nombrePersona}',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 21.0,
                      ),
                      ),
                      subtitle: Text('${items[position].nombrePizza}',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.0,
                        ),                      
                      ),

                      leading: Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 20.0,
                            child: Text('${position + 1}', style: TextStyle(color: Colors.white) ,),
                          )
                        ],
                      ),
                      onTap: () => _navigateToPedidoAdmin(context, items[position])),
                      ),
                      
                      
                    ],
                  )
                ],
              );
            },),
       ),         
     );
  }
    void _navigateToPedidoAdmin(BuildContext context, PedidosPizzas pedidopizza)async{
    await Navigator.push(context, 
      MaterialPageRoute(builder: (context) => AdminPedidoInfo(pedidopizza)),
      );
      
  }
    void _onProductAdd(Event event){
    setState(() {
     items.add(PedidosPizzas.fromSnapShop(event.snapshot)) ;
    });
  }

  void _onProductUpdate(Event event){
      var oldProductValue = items.singleWhere((pedidopizzas) => pedidopizzas.id == event.snapshot.key);

    setState(() {
     items[items.indexOf(oldProductValue)] = PedidosPizzas.fromSnapShop(event.snapshot);
    });
  }
}
 */