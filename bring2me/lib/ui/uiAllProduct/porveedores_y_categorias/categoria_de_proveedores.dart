import 'package:bring2me/ui/uiAllProduct/productos/productos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaProveedoresYCartegoria extends StatelessWidget {
  const ListaProveedoresYCartegoria(
      {Key key, @required this.width, this.height, this.isLargeImg = false,
       this.docProv, this.docCatGen, this.usu, this.userDoc})
      : super(key: key);

  final double height;
  final double width;
  final bool isLargeImg;
  final DocumentSnapshot docProv;
  final DocumentSnapshot docCatGen;
  final FirebaseUser usu;
  final DocumentSnapshot userDoc;

  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),

          SizedBox(height: 15),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext c, BoxConstraints constr) {
                return new StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('ciudad').document("Esmeraldas").collection('categoriaGen').document(docCatGen.documentID).collection('proveedor').document(docProv.documentID).collection('categoria').snapshots(),      
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
                      return Container(
                      width: constr.maxWidth ,
                      height: constr.maxHeight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:  snapshot.data.documents.length,
                        itemBuilder: (context, index){
                        final catProvDoc = snapshot.data.documents[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                width: isLargeImg
                                    ? constr.maxWidth * .8
                                    : constr.maxWidth * .6,
                                height: constr.maxHeight,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    InkWell(
                                      child: Container(
                                          height: constr.maxHeight * .65,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage("${catProvDoc.data["imagen_cat"]}"),
                                              colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.2),
                                                BlendMode.hardLight,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          print("${catProvDoc.data["nombre_cat"]}");
                                           Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => ListProductos(catGenDoc: docCatGen, 
                                                catProvDoc: catProvDoc , proveDoc: docProv, usu: usu, userDoc: userDoc,)
                                              ));
                                          /* _verProductoDialog(context, catProvDoc, user); */
                                        },
                                    ),
                                    
                                    SizedBox(height: 10),
                                    Row(
                                      children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 175.0,
                                            child: Text(
                                            "${catProvDoc.data["nombre_cat"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                        ),
                                          ),
                                          SizedBox(
                                            width: 175.0,
                                            child: Text(
                                              
                                                "${catProvDoc.data["nombre_cat"]}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                          )
                                        
                                        ],
                                      ),
                                      InkWell(
                                          child: Icon(Icons.arrow_forward),
                                          onTap: (){
                                            print("soy un ${catProvDoc.data["nombre_cat"]}");
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => ListProductos(catGenDoc: docCatGen, proveDoc: docProv, catProvDoc: catProvDoc , )
                                              ));
                                            /* _verProductoDialog(context, catProvDoc, user); */
                                          },

                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "hi",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        
/*                                         Text(
                                          "\$${catProvDoc.data["precio_pro"]}",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "\$${catProvDoc.data["precio_pro"]}",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          ),
                                        ), */
                                        
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                        }
                      ),
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
Future<Null> _verProductoDialog(BuildContext context, DocumentSnapshot prodDoc, FirebaseUser user) {
     Firestore.instance.collection('ciudad').document("ORYrQioVN7Pny0KZ6Mg7").collection('proveedor')
     .document("27xbICfN52yat7hdcokl").collection('categoria').document("oXFXAEsAXyNHQx71rOmR")
     .collection('producto').document(prodDoc.documentID).get().then((DocumentSnapshot userDoc) {
   
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text('${prodDoc['nombre_pro']}', style: TextStyle(fontSize: 30.0),),
              content: Container(
                height: 350.0,
                width: 150.0,
                child: ListView(
                  children: <Widget>[
                    SizedBox(                          
                            width: 250.0,
                            height: 150.0,
                            child: Image.network('${prodDoc['imagen_pro']}', width: 40),     
                    ),//imagen
                  Padding(padding: EdgeInsets.only(top: 15.0),),
                  Divider(),
                  Text("Descripcion", style: TextStyle(fontSize: 15.0),),
                    Text('${prodDoc['descripcion_pro']}', style: TextStyle(fontSize: 20.0),),
                    Padding(padding: EdgeInsets.only(top: 15.0),),
                  Divider(),
                  Text("Precio", style: TextStyle(fontSize: 15.0),),
                    Text(' ${prodDoc['precio_pro']}', style: TextStyle(fontSize: 20.0),),
                
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
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: (){
                      CloudFunctions.instance.call(
                        functionName: "crearPedidoUsu",
                        parameters: {
                          "doc_id": user.uid,
                          "uid": prodDoc['uid'],
                          "nombre": prodDoc['nombre_pro'],
                          "descripcion": prodDoc['descripcion_pro'],
                          "precio": prodDoc['precio_pro'],
                          "imagen": prodDoc['imagen_pro'],
                        }
                      );
                      
                       CloudFunctions.instance.call(
                        functionName: "crearPedidoAdminBring",
                        parameters: {
                          "nombres": user.displayName,
                          "correo": user.email,
                          "telefono": userDoc.data['telefono'],
                          "nombrePizza": prodDoc['nombre_pro'],
                          "descripcion": prodDoc['descripcion_pro'],
                          "precio": prodDoc['precio_pro'],
                          "imagen": prodDoc['imagen_pro'],
                        }
                      );  

                  },)
              ],
            );
          }
        );
        });
        

  } 

}
