import 'package:bring2me/ui/uiAllProduct/porveedores_y_categorias/categoria_de_proveedores.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color primaryColor = Colors.blueGrey;
String subCat;

class ProveYCat extends StatelessWidget {
  ProveYCat({Key key, @required this.docCatGen, this.usu, this.userDoc}) : super(key: key);
  final DocumentSnapshot docCatGen;
  final FirebaseUser usu;
  final DocumentSnapshot userDoc;
 
  
  
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
                                        docCatGen.data["nombre_cat_gen"],
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
      top: (height * .15) + 27,
      width: width,
      height: height - (height * .35) + 130,
      child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document('Esmeraldas').collection('categoriaGen').document(docCatGen.documentID).collection('proveedor').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            //print(logger);
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 285.0,),
                  Text('Cargando Ciudades...'),
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
                  final catProvDoc = snapshot.data.documents[index];

                  return InkWell(
                       onTap:() {
                         /* _verCategoriaDialog(context, ciudadDoc); */
                        
                         },
                       child: Column(                         
                         children: <Widget>[                           
                           Row(
                             children: <Widget>[                               
                               Expanded(                                 
                                 child: Padding(
                                   padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                   child: Column(
                                     children: <Widget>[
                                       Padding(
                                         padding: const EdgeInsets.only(right: 120),
                                         child: Text(catProvDoc['nombre_prov'],
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            )
                                            ),
                                            )
                                       
                                       
                                                                              
                                     ],
                                   )
                                 )
                                
                               ),
                               IconButton(
                                 icon: Icon(Icons.arrow_forward, color: Colors.blue,),
                                     onPressed: (){
                                        /* Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => ListViewCategoriasGen(ciu: ciudadDoc)
                                                    )); */
                                     },
                                  )
                               
                             ],
                             
                           ),
                           Padding(
                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                             child: ListaProveedoresYCartegoria(
                                      width: 350.0,
                                      height: 250.0,
                                      isLargeImg: "300" == "3500",
                                      docProv: catProvDoc,
                                      docCatGen: docCatGen,
                                      usu: usu,
                                      userDoc: userDoc,
                                   ),  
                           )
                         
                         ],
                       )
                    );
              }
          );
        }
    )
    );
  }
}
