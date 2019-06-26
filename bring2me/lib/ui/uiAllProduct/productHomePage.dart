import 'package:bring2me/ui/uiAllProduct/pedidos/pedidos_en_proceso/pedido_en_proceso.dart';
import 'package:bring2me/ui/uiAllProduct/pedidos/relizar_pedido/pre_pedidos.dart';
import 'package:bring2me/ui/uiAllProduct/porveedores_y_categorias/pove_y_cat_list.dart';
import 'package:bring2me/ui/uiAllProduct/productos/promociones/lista_prov_promo.dart';
import 'package:bring2me/ui/userProfile/userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({Key key, @required this.usu}) : super(key: key);
  
  final FirebaseUser usu;

  
  @override
  _ProductHomePageState createState() => new _ProductHomePageState();
 }
class _ProductHomePageState extends State<ProductHomePage>  {
  
  
  Color primaryColor = Colors.blueGrey;
  
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido a BRING2ME"),
        backgroundColor: Colors.blueGrey,
      ),
      bottomNavigationBar: _contruccionBottomBar(),
         drawer: _drawer(), 
      body: _streambuilder(context)
      /* _construccionCuerpo(height, width, widget.docUsu), */
    );
  }

  Widget _streambuilder(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
           stream: Firestore.instance
                     .collection('usuarios')
                      .document(widget.usu.displayName)
                      .snapshots(),
            builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
               if (!snapshot.hasData || snapshot.data == null) {
                  //print(logger);
                  return Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 285.0,),
                        Text('Iniciando Bring2M2...'),
                        SizedBox(height: 15.0,),
                        CupertinoActivityIndicator(            
                              ),
                      ],
                    ),
                      
                  );
                }
               return _construccionCuerpo(height, width, snapshot.data);
            }              
    );
  }
  
  Widget _construccionCuerpo(height, width, DocumentSnapshot docUsu) {
    return Container(
      height: height,
      width: width,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          //Fondo de color
          Positioned(
            top: 0,
            width: width,
            height: height * .285,
            //Fondo de color
            child: Container(
              color: primaryColor,
              padding: EdgeInsets.only(left: 20),
              child: SafeArea(
                child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 15),
                        _construccionAppBar(height, width, docUsu),
                        SizedBox(height: 15),
                        Container(
                          width: width - 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black87,
                              ),
                              hintText: 'Buscalo, encuentralo y pidelo ahora...',
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Categorias",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ),
            ),
          ),
          _recuperarCategoriasGenerales(height, width, docUsu),
         Padding(
           padding: EdgeInsets.fromLTRB(100.0, 270.0, 100.0, 100.0),
           child:   Text("PROMOCIONES",
           style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                      ),
                    ),       
         ),
         ListaProvPromo(
            width: width,
            height: height,
            docUsu: docUsu,
          ),  
     
        ],
      ),
    );
  }

  Widget _construccionAppBar(height, width, DocumentSnapshot docUsu) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Hola, ${docUsu.data["nombres"]}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Que vas a pedir ?",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Container(
          width: 60,
          alignment: Alignment.centerLeft,
          child: Stack(
            children: <Widget>[
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.message,
                  color: Colors.black87,
                  size: 28,
                ),
              ),
              Positioned(
                top: 0,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
   StreamBuilder<QuerySnapshot> _recuperarCategoriasGenerales(height, width, DocumentSnapshot docUsu) {
     
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categoriaGeneral').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        
          if (!snapshot.hasData || snapshot.data == null) {
            //print(logger);
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 285.0,),
                  Text('Cargando CATEGORIAS...'),
                  SizedBox(height: 15.0,),
                  CupertinoActivityIndicator(            
                        ),
                ],
              ),
                
             );
          }
          return Positioned(
              width: width,
              height: 100,
              top: (height * .29) - 45,
              child: ListView.builder(
                itemCount:  snapshot.data.documents.length,                
                padding: EdgeInsets.only(left: 20.0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){

                final catGenDoc = snapshot.data.documents[index];
                final int newItemCount = 0 ;
                
                return Container(
                  height: 90,
                  width: 110,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 90,
                        height: 90,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (c) => ProveYCat(docCatGen: catGenDoc, usu: widget.usu, userDoc: docUsu,)
                              ),
                            );/* 
                            _contruccionContenidos(height, width); */
                          },
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.network("${catGenDoc.data["imagen_cat_gen"]}", width: 60.0,),/* 
                                Icon(
                                  Icons.event_seat,
                                  size: 40,
                                ), */
                                Text(
                                  "${catGenDoc.data["nombre_cat_gen"]}",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newItemCount != 0,
                        child: Positioned(
                          top: 8,
                          right: 10,
                          child: Container(
                            width: 30,
                            height: 20,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              newItemCount.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

/*                     children: List.generate(
                    
                    15,
                    (int index) =>
                        FurnitureCategoryItem(newItemCount: index % 3 == 0 ? 40 : 0),
                  ).toList(); */
                },

              ),
            );
        }
    );

  }
 
  Widget _contruccionBottomBar() {
    return StreamBuilder<DocumentSnapshot>(
           stream: Firestore.instance
                     .collection('usuarios')
                      .document(widget.usu.displayName)
                      .snapshots(),
            builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                          //print(logger);
                          return Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 285.0,),
                                Text('Iniciando Bring2M2...'),
                                SizedBox(height: 15.0,),
                                CupertinoActivityIndicator(            
                                      ),
                              ],
                            ),
                              
                          );
                        }
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
                                Icons.favorite_border,
                                color: Colors.black54,
                                size: 30,
                              ),
                              IconButton(
                                icon: Icon(Icons.shopping_cart),
                                iconSize: 30.0,
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ListViewPrePedidos(docUsu: snapshot.data,)
                                      ));
                                },
                              ),
                            
                              IconButton(
                                icon: Icon(Icons.perm_identity, 
                                  size: 30.0,),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => UserProfile(usuDoc: snapshot.data, user: widget.usu,)
                                      ));
                                  },              
                              ),
                            ],
                          ),
                        ),
                      );
            });
    
  }

Widget _drawer() {
  return StreamBuilder<DocumentSnapshot>(
           stream: Firestore.instance
                     .collection('usuarios')
                      .document(widget.usu.displayName)
                      .snapshots(),
            builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
               if (!snapshot.hasData || snapshot.data == null) {
                  //print(logger);
                  return Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 285.0,),
                        Text('Iniciando Bring2M2...'),
                        SizedBox(height: 15.0,),
                        CupertinoActivityIndicator(            
                              ),
                      ],
                    ),
                      
                  );
                }
               return Drawer(
                  elevation: 20.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName: Text(snapshot.data["nombres"]),
                        accountEmail: Text(snapshot.data["correo"]),
                        currentAccountPicture: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => UserProfile(user: widget.usu, usuDoc: snapshot.data,)
                                              ));
                          },
                          child: CircleAvatar(                    
                          backgroundImage: snapshot.data["foto"] != "" ? NetworkImage(snapshot.data["foto"]) 
                                            : NetworkImage("https://insidelatinamerica.net/wp-content/uploads/2018/01/noImg_2.jpg"), 
                        ),
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
                                backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/bring2me-e3467.appspot.com/o/logojpg.jpg?alt=media&token=bf5a8da1-ec3c-4780-9254-8d0b9470a0cc") , 
                              ),
                            )
                          ],

                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ListViewPedidosEnProceso(docUsu: snapshot.data)
                                            ));
                        },
                          child:  ListTile(
                          title: Text("Pedidos en Proceso", style: TextStyle(fontSize: 15.0),),
                          trailing: Icon(Icons.list),
                                            ),
                      ),
                      InkWell(
                        onTap: (){
                          print("hi");
                        },
                          child:  ListTile(
                          title: Text("Pedido Realizados", style: TextStyle(fontSize: 15.0),),
                          trailing: Icon(Icons.list),
                        
                        ),
                      )              
                    
                    ],
                  )
                );
            }
              
    );
    
  }
 
}



/* 
Color primaryColor = Color(0xffdc2f2e);

class FurnitureHome extends StatelessWidget {
  const FurnitureHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: _buildBottomBar(),
      body: _buildBody(height, width),
    );
  }

  Widget _buildBottomBar() {
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
              Icons.adjust,
              color: Colors.black54,
              size: 30,
            ),
            Icon(
              Icons.shopping_cart,
              size: 30,
              color: Colors.black54,
            ),
            Icon(
              Icons.message,
              color: Colors.black54,
              size: 30,
            ),
            Icon(
              Icons.perm_identity,
              color: Colors.black54,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(height, width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Hello, Marshall",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Want to buy unique furniture ?",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Container(
          width: 60,
          alignment: Alignment.centerLeft,
          child: Stack(
            children: <Widget>[
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                  size: 28,
                ),
              ),
              Positioned(
                top: 0,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(height, width) {
    return Container(
      height: height,
      width: width,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            width: width,
            height: height * .35,
            child: Container(
              color: primaryColor,
              padding: EdgeInsets.only(left: 20),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15),
                    _buildAppBar(height, width),
                    SizedBox(height: 30),
                    Container(
                      width: width - 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black87,
                          ),
                          hintText: 'Search unique furniture now...',
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          _buildCategoriesSection(height, width),
          _buildContent(height, width),
        ],
      ),
    );
  }

  Widget _buildContent(height, width) {
    return Positioned(
      top: (height * .35) + 50,
      width: width,
      height: height - (height * .35) + 50,
      child: LayoutBuilder(
        builder: (BuildContext c, BoxConstraints constraints) {
          final List<Widget> items = [];
          furnitureResult.forEach((item) {
            items.add(
              FurnitureContentSection(
                width: constraints.maxWidth,
                height: constraints.maxHeight * .50,
                isLargeImg: item.price == "3500",
              ),
            );
          });

          items.add(SizedBox(
            height: constraints.maxHeight / 3,
          ));

          return ListView(
            padding: EdgeInsets.only(left: 20),
            children: items,
          );
        },
      ),
    );
  }

  Widget _buildCategoriesSection(height, width) {
    return Positioned(
      width: width,
      height: 100,
      top: (height * .35) - 45,
      child: ListView(
        padding: EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        children: List.generate(
          10,
          (int index) =>
              FurnitureCategoryItem(newItemCount: index % 3 == 0 ? 40 : 0),
        ).toList(),
      ),
    );
  }
}
 */