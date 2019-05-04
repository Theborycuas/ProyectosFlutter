import 'package:bring2me/ui/uiAllProduct/furniture-category-home.dart';
import 'package:bring2me/ui/uiAllProduct/productPrincipalPage/KFC/alitasKfc.dart';
import 'package:bring2me/ui/uiAllProduct/productPrincipalPage/KFC/combosKfc.dart';
import 'package:bring2me/ui/uiAllProduct/productPrincipalPage/KFC/hamburguesasKfc.dart';
import 'package:bring2me/ui/uiAllProduct/productPrincipalPage/Menestras%20del%20Negro/postres.dart';
import 'package:bring2me/ui/userProfile/userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({Key key, @required this.docUsu, this.usu}) : super(key: key);
  final DocumentSnapshot docUsu;
  final FirebaseUser usu;
  @override
  _ProductHomePageState createState() => new _ProductHomePageState();
 }
class _ProductHomePageState extends State<ProductHomePage> {
    
  Color primaryColor = Colors.blueGrey;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido a BRING2ME"),
        backgroundColor: Colors.blueGrey,
      ),
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
            IconButton(
              icon: Icon(Icons.perm_identity, 
                size: 30.0,),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => UserProfile(usuDoc: widget.docUsu, user: widget.usu,)
                    ));
                },              
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
              "Hola, ${widget.docUsu["nombres"]}",
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
                          hintText: 'Buscalo, encuentralo y pidelo ahora...',
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
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
              ),
            ),
          ),
          _recuperarCategoriasGenerales(height, width),
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
          
            items.add(
              AlitasKfc(
                width: constraints.maxWidth,
                height: constraints.maxHeight * .50,
                isLargeImg: "300" == "3500",
              ),
            );
            items.add(
              CombosKfc(
                width: constraints.maxWidth,
                height: constraints.maxHeight * .50,
                isLargeImg: "300" == "3500",
              ),
            );
            items.add(
              HamburguesasKfc(
                width: constraints.maxWidth,
                height: constraints.maxHeight * .50,
                isLargeImg: "300" == "3500",
              ),
            );
            items.add(
              PostresMenestrasNegro(
                width: constraints.maxWidth,
                height: constraints.maxHeight * .50,
                isLargeImg: "300" == "3500",
              ),
            );            

          items.add(SizedBox(
            height: constraints.maxHeight / 5,
          ));

          return ListView(
            padding: EdgeInsets.only(left: 20),
            children: items,
          );
        },
      ),
    );
  }


   StreamBuilder<QuerySnapshot> _recuperarCategoriasGenerales(height, width) {
     
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
              top: (height * .35) - 45,
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
                                builder: (c) => FurnitureCategoryHome(),
                              ),
                            );
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