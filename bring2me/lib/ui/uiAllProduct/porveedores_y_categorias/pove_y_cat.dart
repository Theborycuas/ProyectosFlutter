import 'package:bring2me/ui/uiAllProduct/porveedores_y_categorias/lista_prov_y_cat.dart';
import 'package:bring2me/ui/uiAllProduct/productPrincipalPage/KFC/alitasKfc.dart';
import 'package:bring2me/ui/uiAllProduct/productPrincipalPage/KFC/combosKfc.dart';
import 'package:bring2me/ui/uiAllProduct/productPrincipalPage/KFC/hamburguesasKfc.dart';
import 'package:bring2me/ui/uiAllProduct/productPrincipalPage/Menestras%20del%20Negro/postres.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Color primaryColor = Color(0xffdc2f2e);
String subCat;

class ProveYCat extends StatelessWidget {
  ProveYCat({Key key, @required this.docCat}) : super(key: key);
  final DocumentSnapshot docCat;
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

     return Scaffold(
      
      body:  Container(
      height: height,
      width: width,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          //Fondo de color
          Positioned(
            top: 0,
            width: width,
            height: height * .185,
            //Fondo de color
            child: Container(
              color: primaryColor,
              padding: EdgeInsets.only(left: 20),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[    
                    SizedBox(height: 25.0,),
                    Container(
                      width: width - 40,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SafeArea(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 6.0,),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      
                                      IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Text(
                                        docCat.data["nombre_cat_gen"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        alignment: Alignment.centerLeft,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black54,
                                                    blurRadius: 3,
                                                  )
                                                ],
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
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),                            
                    ),
                    /* SizedBox(height: 15),
                    TextField(
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
                    Text(
                      "Categorias",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ) */
                  ],
                ),
              ),
            ),
          ),
          _contruccionContenidos(height, width),
        ],
      ),
    )
    );
  }

  Widget _contruccionContenidos(height, width) {
    return Positioned(
      top: (height * .15) + 50,
      width: width,
      height: height - (height * .35) + 50,
      child: LayoutBuilder(
        builder: (BuildContext c, BoxConstraints constraints) {
          final List<Widget> items = [];
          

            items.add(
              PruebaListaProveedoresYCartegoria(
                width: constraints.maxWidth,
                height: constraints.maxHeight * .50,
                isLargeImg: "300" == "3500",
              ),
            );
            items.add(
              PruebaListaProveedoresYCartegoria(
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
}
