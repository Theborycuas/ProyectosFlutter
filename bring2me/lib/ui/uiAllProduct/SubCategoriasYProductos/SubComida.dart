import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Color primaryColor = Color(0xffdc2f2e);
String subCat;

class FurnitureCategoryHome extends StatelessWidget {
  FurnitureCategoryHome({Key key, @required this.docCat}) : super(key: key);
  final DocumentSnapshot docCat;
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
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
            SizedBox(height: 10),
            Container(
              height: 50,
              width: width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 10),
                children: <Widget>[
                 /*  _buildCategoryItem(
                    width: 70.0,
                  /*   child: Icon(
                      Icons.tune,
                      size: 32.0,
                    ), */
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext c) {
                          return new Container(
                            height: height * .6,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ), */
                  _buildCategoryItem(
                    width: 100.0,
                    subCat: "Cerveza"
                  ),
                  _buildCategoryItem(
                    width: 100.0,
                    subCat: "Vino"
                  ),
                  _buildCategoryItem(
                     width: 100.0,
                    subCat: "Whisky"                    
                  ),
                  _buildCategoryItem(
                    width: 100.0,
                    subCat: "Tequila"
                  ),
                  _buildCategoryItem(
                    width: 100.0,
                    subCat: "Vodka"
                  ),
                  _buildCategoryItem(
                     width: 100.0,
                    subCat: "Ron"                    
                  ),
                  _buildCategoryItem(
                    width: 100.0,
                    subCat: "Ginebra"
                  ),
                  _buildCategoryItem(
                    width: 100.0,
                    subCat: "Brandy"
                  ),                                

                  
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  /* Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildItem(width),
                      _buildItem(width),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildItem(width),
                      _buildItem(width),
                    ],
                  ), */
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildItem(width),
                      _buildItem(width),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  Widget _buildItem(double width) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 5, 5),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: width * .4,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(
                  Icons.favorite_border,
                  color: primaryColor,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 210,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(
                            "https://www.california-chiavari-chairs.com/v/vspfiles/photos/7900RFW-2T.jpg"),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Backless Silver"),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 15,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 15,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 15,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 15,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 15,
                          ),
                        ],
                      ),
                      Container(
                        width: 100,
                        child: Divider(
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "\$30",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({width, String subCat, color = Colors.white, onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Container(
          alignment: Alignment.center,
          height: 40,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: InkWell(            
            child: Text(
                      "${subCat}",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
            onTap: (){
                      switch(subCat.toString()) { 
                                  case "Cerveza": {  
                                    print("cerveza");
                                    } 
                                  break; 
                                
                                  case "Vino": {  
                                    
                                    } 
                                  break; 
                                
                                  case "Whisky": {  
                                    
                                    } 
                                  break; 
                                
                                  case "Tequila": {  
                                    
                                    } 
                                  break; 
                                  case "Vodka": {  
                                    
                                    } 
                                  break;
                                  case "Ron": {  
                                   
                                    } 
                                  break;
                                  case "Ginegra": {  
                                    
                                    } 
                                  break;
                                  case "Brandy": {  
                                    
                                    } 
                                  break;
                                
                                  default: { print("Incorrecto"); } 
                                  break; 
                              }

              /* 
                  print("Hola soy "+child.); */
            },
          ),
        ),
      ),
    );
  }
}
