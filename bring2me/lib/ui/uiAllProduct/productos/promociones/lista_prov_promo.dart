import 'package:bring2me/ui/uiAllProduct/productos/productos.dart';
import 'package:bring2me/ui/uiAllProduct/productos/promociones/lista_promociones.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaProvPromo extends StatelessWidget {
  const ListaProvPromo({Key key, @required this.width, this.height, this.docUsu}) : super(key: key);

  final double height;
  final double width;
  final DocumentSnapshot docUsu;

  @override
  Widget build(BuildContext context) {
  return Positioned(
      top: (height * .15) +  190,
      width: width,
      height: height - (height * .5) - 75,
      child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ciudad').document('Esmeraldas').collection('categoriaGen').document('COMIDA').collection('proveedor').snapshots(),
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
          else{
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
                             child: ListaPromocinones(
                                      width: 350.0,
                                      height: 250.0,
                                      isLargeImg: "300" == "3500",
                                      docCatProv: catProvDoc,
                                      docUsu: docUsu,
                                   ),  
                           ) 
                         
                         ],
                       )
                    );
              }
          );

          }
       
        }
    )
    );
  }/* 
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
        

  }  */

}
