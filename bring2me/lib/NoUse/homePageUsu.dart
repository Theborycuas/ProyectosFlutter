import 'package:bring2me/ui/listProductUsu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class HomePageUsu extends StatefulWidget {
  const HomePageUsu({Key key, @required this.user, this.usuDoc}):super(key:key);
  final FirebaseUser user;
  final DocumentSnapshot usuDoc;
  @override
  _HomePageUsuState createState() => new _HomePageUsuState();
 }
class _HomePageUsuState extends State<HomePageUsu> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('CATEGORIAS'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){
              
            },
          )
        ],
      ),
       drawer: Drawer(
        elevation: 20.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.usuDoc.data["nombres"]),
              accountEmail: Text(widget.usuDoc.data["correo"]),
              currentAccountPicture: CircleAvatar(
                backgroundImage: widget.usuDoc.data["foto"] != "" ? NetworkImage(widget.usuDoc.data["foto"]) : NetworkImage("https://insidelatinamerica.net/wp-content/uploads/2018/01/noImg_2.jpg"), 
              ),
              
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                /* image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage("${widget.user.photoUrl}"),
                ) */),
                otherAccountsPictures: <Widget>[
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: widget.usuDoc.data["foto"] != "" ? NetworkImage(widget.usuDoc.data["foto"]) : NetworkImage("https://insidelatinamerica.net/wp-content/uploads/2018/01/noImg_2.jpg") , 
                    ),
                  )
                ],

            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Hola"),
              trailing: Icon(Icons.settings),
              onTap: (){

              },
            )
          ],
        )
      ), 
      body: Center(
        child: _recuperarCategorias(),
      ),
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
                   
                    child: InkWell(
                       onTap:() {
                         Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ListViewProductUsu(cat: categoriaDoc, user: widget.user)
                                      ));
                        /*  _verCategoriaDialog(context, categoriaDoc); */
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

  Future<Null> _actualizarCategoriaDialog(BuildContext context, DocumentSnapshot categoriaDoc) {
    TextEditingController _nombreController = new TextEditingController(text: categoriaDoc['nombre_cat']);
    TextEditingController _descripcionController = new TextEditingController(text: categoriaDoc['descripcion_cat']);
    TextEditingController _imagen = new TextEditingController(text: categoriaDoc['imagen_cat']);

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
  
  Future<Null> _verCategoriaDialog(BuildContext context, DocumentSnapshot categoriaDoc) {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('${categoriaDoc['nombre_cat']}'),
          content: Container(
            height: 320.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                SizedBox(                          
                        width: 250.0,
                        height: 150.0,
                        child: Image.network('${categoriaDoc['imagen_cat']}', width: 40),     
                ),//imagen               
               Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
                Text('${categoriaDoc['descripcion_cat']}'),
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


/* import 'package:bring2me/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart' as wheel;
import 'package:bring2me/ui/categoriasCircleScroll.dart';

class HomePageUsu extends StatefulWidget {
  @override
  _HomePageUsuState createState() => _HomePageUsuState();
}

class _HomePageUsuState extends State<HomePageUsu> {
  wheel.FixedExtentScrollController _controller;

 _listListener() {
    setState(() {});
  }
 
  @override
  void initState() {
    _controller = wheel.FixedExtentScrollController();
    _controller.addListener(_listListener);
    super.initState();
  }
/* 
  @override
  void dispose() {
    _controller.removeListener(_listListener);
    _controller.dispose();
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    int i;
    return StreamBuilder(
          stream: Firestore.instance.collection('categoria').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                return   Scaffold(
                  
                backgroundColor: Color(0xFF2F6FE0),
                appBar: AppBar(
                  title: Text("HOME"),
                  backgroundColor: Colors.black,
                ),
                body: wheel.CircleListScrollView.useDelegate(
                  onSelectedItemChanged:  (i) => i==1?print('uno'):print('2'),
                  childDelegate: wheel.CircleListChildBuilderDelegate(
                    builder: (context, index) {
                   //   categoriaDoc = snapshot.data.documents[index];

                      int currentIndex = 0;
                      try {
                        currentIndex = _controller.selectedItem;
                      } catch (_) {}
                      final resizeFactor =
                          (1 - (((currentIndex - index).abs() * 0.3).clamp(0.0, 1.0)));
                      return new  CircleListItem(
                            resizeFactor: resizeFactor,
                            categoriaDoc: snapshot.data.documents[index],
                            //character: characters[index],   
                          );
                    },
                    
                    childCount: snapshot.data.documents.length,
                  ),
                  physics: wheel.CircleFixedExtentScrollPhysics(),
                  controller: _controller,
                  axis: Axis.vertical,
                  itemExtent: 120,
                  radius: MediaQuery.of(context).size.width * 1.0,
                  
                ),
              );
          }
    );
  }
  
}

class CircleListItem extends StatelessWidget {
  final double resizeFactor;/* 
  final Character character; */
  const CircleListItem({Key key, this.resizeFactor, this.categoriaDoc})
      : super(key: key);
  final DocumentSnapshot categoriaDoc;
  @override
  Widget build(BuildContext context) {
    return  Center(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        categoriaDoc['nombre_cat'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22 * resizeFactor,
                        ),
                      ),
                    ),
                    Container(
                      width: 120 * resizeFactor,
                      height: 120 * resizeFactor,
                      
                      child: Align(
                        child: Container(
                          child: Image.network('${categoriaDoc['imagen_cat']}', width: 40),
                          decoration: BoxDecoration(
                            
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.blue,
                          ),
                          height: 110 * resizeFactor,
                          width: 110 * resizeFactor,
                        ),
                      ),
                    ),
                  ]),
                );        
   
  }
} */