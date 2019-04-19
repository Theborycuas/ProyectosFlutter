
import 'package:bring2me/adminUI/AdminCrearCategoria.dart';
import 'package:bring2me/adminUI/AdminCrearProductos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class ListViewProduct extends StatefulWidget {
  @override
  _ListViewProductState createState() => new _ListViewProductState();
 }
class _ListViewProductState extends State<ListViewProduct> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('PRODUCTOS'),
      ),
      body: Center(
        child: _recuperarCategorias(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>ProductScreenPizzas())),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
StreamBuilder<QuerySnapshot> _recuperarCategorias() {

    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categoria').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("No existen Categorias creadas.");
            //print(logger);
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final categoriaDoc = snapshot.data.documents[index];

                  return Dismissible( // <--------------------------NEW CODE-----------------
                    key: new Key(snapshot.data.documents[index].documentID),
                    direction: DismissDirection.horizontal,
                    onDismissed: (DismissDirection direction) {
                      if (direction != DismissDirection.horizontal) {
                          Firestore.instance.collection('categoria').document(categoriaDoc.documentID).delete();
                      }
                    },
                    child: InkWell(
                       onTap:() {
                         _recuperarPedidos(categoriaDoc);
                         },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(categoriaDoc['nombre_cat']),
                                      subtitle: new Text(categoriaDoc['descripcion_cat']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${categoriaDoc['imagen_cat']}', width: 40),
                                      ],
                                    ),
                                 ),
                               ),
                               IconButton(
                                icon: Icon(Icons.delete, color: Colors.red,),
                                  onPressed: (){
                                    Firestore.instance.collection('categoria').document(categoriaDoc.documentID).delete();
                                  },
                                 ),
                               IconButton(
                                 icon: Icon(Icons.edit, color: Colors.blue,),
                                     onPressed: (){
                                       _actualizarCategoriaDialog(context, categoriaDoc);
                                     },
                                  )
                               
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
Future<Null> _recuperarPedidos(DocumentSnapshot categoriaDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
           title: Text('PRODUCTOS'),
          content: Container(
            
            height: 820.0,
            width: 800.0,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('categoria').document(categoriaDoc.documentID).collection('producto').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    print("No existen Categorias creadas.");
                    //print(logger);
                    return Container();
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {

                          final productoDoc = snapshot.data.documents[index];

                          return InkWell(
                              onTap:() {
                                _verCategoriaDialog(context, productoDoc);
                                },
                                child:
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ListTile(
                                              title: new Text(productoDoc['nombre_pro']),
                                              subtitle: new Text(productoDoc['descripcion_pro']),
                                              leading: Image.network('${productoDoc['imagen_pro']}', width: 50),
                                              
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red,),
                                          onPressed: (){
                                            Firestore.instance.collection('categoria').document(categoriaDoc.documentID).collection('producto').document(productoDoc.documentID).delete();
                                          },
                                        ),
                                      
                                    ],
                                    
                                  )
                            );
                      }
                  );

                }
            ),
          ),

        );
      }
    );
  }
  Future<Null> _actualizarCategoriaDialog(BuildContext context, DocumentSnapshot categoriaDoc) {
    TextEditingController _nombreController = new TextEditingController(text: categoriaDoc['nombre']);
    TextEditingController _descripcionController = new TextEditingController(text: categoriaDoc['descripcion']);
    TextEditingController _imagen = new TextEditingController(text: categoriaDoc['imagen']);

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
                  decoration: new InputDecoration(labelText: "Nombre: "),

                ),
                new TextField(
                  controller: _descripcionController,
                  decoration: new InputDecoration(labelText: "Descripcion: "),
                ),                
                new TextField(
                  controller: _imagen,
                  decoration: new InputDecoration(labelText: "Imagen: "),
                ),

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
                      functionName: "updateCategoria",
                      parameters: {
                        "doc_id": categoriaDoc.documentID,
                        "nombre": _nombreController.text,
                        "descripcion": _descripcionController.text,
                        "imagen": _imagen.text
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
  
  Future<Null> _verCategoriaDialog(BuildContext context, DocumentSnapshot categoriaDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('${categoriaDoc['nombre']}'),
          content: Container(
            height: 320.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                SizedBox(                          
                        width: 250.0,
                        height: 150.0,
                        child: Image.network('${categoriaDoc['imagen']}', width: 40),     
                ),//imagen               
               Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
                Text('${categoriaDoc['descripcion']}'),
                Padding(padding: EdgeInsets.only(top: 15.0),),
                             

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


/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class ListViewProductPizza extends StatefulWidget {
  @override
  _ListViewProductPizzaState createState() => new _ListViewProductPizzaState();
 }
class _ListViewProductPizzaState extends State<ListViewProductPizza> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('PRODUCTOS'),
      ),
      body: Center(
        child: _recuperarPizzas(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.push(context, MaterialPageRoute(
          builder: (context)=>ProductScreenPizzas())),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
StreamBuilder<QuerySnapshot> _recuperarPizzas() {

    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categoria').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("No existen Pizzas creadas.");
            //print(logger);
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final pizzaDoc = snapshot.data.documents[index];

                  return Dismissible( // <--------------------------NEW CODE-----------------
                    key: new Key(snapshot.data.documents[index].documentID),
                    direction: DismissDirection.horizontal,
                    onDismissed: (DismissDirection direction) {
                      if (direction != DismissDirection.horizontal) {
                          Firestore.instance.collection('pizzas').document(pizzaDoc.documentID).delete();
                      }
                    },
                    child: InkWell(
                       onTap:() {_verPizzaDialog(context, pizzaDoc);},
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(pizzaDoc['nombre']),
                                      subtitle: new Text(pizzaDoc['descripcion']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${pizzaDoc['imagen']}', width: 40),
                                      ],
                                    ),
                                 ),
                               ),
                               IconButton(
                                icon: Icon(Icons.delete, color: Colors.red,),
                                  onPressed: (){
                                    Firestore.instance.collection('pizzas').document(pizzaDoc.documentID).delete();
                                  },
                                 ),
                               IconButton(
                                 icon: Icon(Icons.edit, color: Colors.blue,),
                                     onPressed: (){
                                       _actualizarPizzaDialog(context, pizzaDoc);
                                     },
                                  )
                               
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

  Future<Null> _actualizarPizzaDialog(BuildContext context, DocumentSnapshot pizzaDoc) {
    TextEditingController _nombreController = new TextEditingController(text: pizzaDoc['nombre']);
    TextEditingController _descripcionController = new TextEditingController(text: pizzaDoc['descripcion']);
    TextEditingController _precioControlles = new TextEditingController(text: pizzaDoc['precio']);
    TextEditingController _imagen = new TextEditingController(text: pizzaDoc['imagen']);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("EDITAR PIZZA"),
          content: Container(
            height: 420.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                new TextField(
                  controller: _nombreController,
                  decoration: new InputDecoration(labelText: "Nombre: "),

                ),
                new TextField(
                  controller: _descripcionController,
                  decoration: new InputDecoration(labelText: "Descripcion: "),
                ),
                new TextField(
                  controller: _precioControlles,
                  decoration: new InputDecoration(labelText: "Precio: "),

                ),
                new TextField(
                  controller: _imagen,
                  decoration: new InputDecoration(labelText: "Imagen: "),
                ),

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
                      functionName: "updatePizza",
                      parameters: {
                        "doc_id": pizzaDoc.documentID,
                        "nombre": _nombreController.text,
                        "descripcion": _descripcionController.text,
                        "precio": _precioControlles.text,
                        "imagen": _imagen.text
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

 */











/* class ListViewProductPizza extends StatefulWidget {
  @override
  _ListViewProductPizzaState createState() => new _ListViewProductPizzaState();
 }

 final productReference = FirebaseDatabase.instance.reference().child('productpizzas');

class _ListViewProductPizzaState extends State<ListViewProductPizza> {

  List<ProductPizzas> items;
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
   return new MaterialApp(
   debugShowCheckedModeBanner: false,
    //titulo de la app
    title: 'Oreganos Pizza',
     home: new Scaffold(
       
       appBar: AppBar( 
         title: Text("Pizzas"),
         centerTitle: true,
         backgroundColor: Colors.green,
         actions: <Widget>[
           new IconButton(
             icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
           ),
         ],
       ),
       body: Center(
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.only(top: 12.0),
            itemBuilder: (context, position){
              return Column(
                children: <Widget>[
                  Divider(height: 7.0,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(title: Text('${items[position].nombre}',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 21.0,
                      ),
                      ),
                      subtitle: Text('${items[position].descripcion}',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.0,
                        ),
                      ),
                      leading: Column(
                        children: <Widget>[
                          SizedBox(width: 50,),
                          Image.network('${items[position].imagen}', width: 20),
                        ],
                      ),
                      onTap: () => _navigateToProductInformation(context, items[position])),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red,),
                        onPressed: () => _deleteProduct(context, items[position], position),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue,),
                        onPressed: () => _navigateToProduct(context, items[position]),
                      )
                    ],
                  )
                ],
              );
            },),
       ),
       floatingActionButton: FloatingActionButton(
         child: Icon(Icons.add, color: Colors.white,),
         backgroundColor: Colors.green, 
         onPressed: () => _createNewProduct(context),),
         
     ),

  
   );
  }

  void _onProductAdd(Event event){
    setState(() {
     items.add(ProductPizzas.fromSnapShop(event.snapshot)) ;
    });
  }

  void _onProductUpdate(Event event){
      var oldProductValue = items.singleWhere((productpizzas) => productpizzas.id == event.snapshot.key);

    setState(() {
     items[items.indexOf(oldProductValue)] =ProductPizzas.fromSnapShop(event.snapshot);
    });
  }

  void _deleteProduct(BuildContext context, ProductPizzas productpizza, int position) async{
    await productReference.child(productpizza.id).remove().then((_){
      setState(() {
       items.removeAt(position);
      });
    });


  }



  void _navigateToProductInformation(BuildContext context, ProductPizzas productpizza)async{
    await Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ProductScreenPizzas(productpizza)),
      );
      
  }

  void _navigateToProduct(BuildContext context, ProductPizzas productpizza)async{
    await Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ProductInformationPizzas(productpizza)),
      );
      
  }

    void _createNewProduct(BuildContext context)async{
      await Navigator.push(context, 
        MaterialPageRoute(builder: (context) => ProductScreenPizzas(ProductPizzas(null,'','','',''))),
        );
      
  }
} */



//SHOW DIALOGO UTIL 


  /* Future<Null> _agregarPizzaDialogBox(BuildContext context) {
    TextEditingController _nombreController = new TextEditingController();
    TextEditingController _descripcionController = new TextEditingController();
    TextEditingController _precioControlles = new TextEditingController();
    TextEditingController _imagen = new TextEditingController();

    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text("Add a contact"),
          content: Container(
            height: 120.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                TextField(
                 controller: _nombreController,
                 style: TextStyle(fontSize: 17.0, color: Colors.green),
                 decoration: InputDecoration(
                   icon: Icon(Icons.local_pizza),
                   labelText: 'Nombre:'
                 ),
               ),
               Padding(padding: EdgeInsets.only(top: 8.0),),
               Divider(),
               TextField(
                 controller: _descripcionController,
                 style: TextStyle(fontSize: 17.0, color: Colors.green),
                 decoration: InputDecoration(
                   icon: Icon(Icons.list),
                   labelText: 'Descripcion:'
                 ),
               ),
               
               Padding(padding: EdgeInsets.only(top: 8.0),),
               Divider(),
              TextField(
                 controller: _precioControlles,
                 style: TextStyle(fontSize: 17.0, color: Colors.green),
                 decoration: InputDecoration(
                   icon: Icon(Icons.monetization_on),
                   labelText: 'Precio'
                 ),
               ),
               Padding(padding: EdgeInsets.only(top: 8.0),),               

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
                    functionName: "crearPizza",
                    parameters: {
                      "nombre": _nombreController.text,
                      "descripcion": _descripcionController.text,
                      "precio": _precioControlles.text,
                      "imagen": _imagen.text,
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
  } */