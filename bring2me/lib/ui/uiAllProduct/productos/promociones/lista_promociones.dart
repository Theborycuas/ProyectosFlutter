import 'package:bring2me/ui/uiAllProduct/productos/productos.dart';
import 'package:bring2me/ui/uiAllProduct/relizar%20pedido/confirmar_direccion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ListaPromocinones extends StatefulWidget {
    const ListaPromocinones({Key key, @required this.width, this.height, this.isLargeImg = false,
    this.docCatProv, this.docUsu}) : super(key: key);

  final double height;
  final double width;
  final bool isLargeImg;
  final DocumentSnapshot docCatProv;  
  final DocumentSnapshot docUsu;
  _ListaPromocinonesState createState() => _ListaPromocinonesState();
}

class _ListaPromocinonesState extends State<ListaPromocinones> {
  

@override
  Widget build(BuildContext context){
    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext c, BoxConstraints constr) {
                return new StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('ciudad').document("Esmeraldas").collection('categoriaGen').document('COMIDA').collection('proveedor').document(widget.docCatProv.documentID).collection('categoria').document('Promociones').collection('productos').snapshots(),      
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
                        final prodDoc = snapshot.data.documents[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Container(
                                width: widget.isLargeImg
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
                                              image: NetworkImage("${prodDoc.data["imagen_pro"]}"),
                                              colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.2),
                                                BlendMode.hardLight,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: (){
                                          _verPromociones(context, prodDoc, widget.docCatProv);
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
                                            "${prodDoc.data["nombre_pro"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                        ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                            SizedBox(
                                              width: 175.0,
                                              child: Text(                                              
                                                  "\$ ${prodDoc.data["precio_pro"]}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    decoration: TextDecoration.lineThrough,
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                            ),

                                            ],
                                          )
                                          
                                        
                                        ],
                                      ),
                                      InkWell(
                                          child: Icon(Icons.shopping_cart),
                                          onTap: (){
                                            _verPromociones(context, prodDoc, widget.docCatProv);
                                            /* 
                                              */
                                                                  },

                                        ),
                                       
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                      Text(                                             
                                           "\$ ${prodDoc.data["precio_pro"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(                                            
                                            fontSize: 16,
                                            color: Colors.grey,
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

  Future<Null> _verPromociones (BuildContext context, DocumentSnapshot prodDoc,
    DocumentSnapshot userDoc){
      TextEditingController _cantidad = TextEditingController(text: '1');
 
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('${prodDoc['nombre_pro']}'),
          content: Container(
            height: 400.0,
            width: 100.0,
            child: ListView(
              children: <Widget>[
                SizedBox(                          
                        width: 250.0,
                        height: 150.0,
                        child: Image.network('${prodDoc['imagen_pro']}', width: 40),     
                ),//imagen               
               Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
               Text("Descripción:"),
                Text('${prodDoc['descripcion_pro']}', style: TextStyle(fontSize: 23.0),),
                Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
               Text("Precio:"),
                Text('\$ ${prodDoc['precio_pro']} c/u', style: TextStyle(fontSize: 23.0),),
                Padding(padding: EdgeInsets.only(top: 15.0),),
                Text("Cantidad:"),
                SizedBox(
                  width: 25.0,
                  height: 50.0,
                  child: TextField(
                  controller: _cantidad,                  

                ),
                )
                
                /* Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: (){},
                    ),
                    SizedBox(
                      width: 30.0,
                      height: 25.0,
                      child: Text('$_contador'),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: (){
                         _incrementCounter();
                      },
                    )

                  ],
                ) */
               

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
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.blueGrey,
                  onPressed: (){ 

                    CloudFunctions.instance.call(
                       functionName: "crearPrePedidoUsu",
                       parameters: {
                          "doc_id": widget.docUsu.documentID,
                          "nombre_pro": prodDoc['nombre_pro'],
                          "descripcion_pro": prodDoc['descripcion_pro'],
                          "precio_pro": prodDoc['precio_pro'],
                          "imagen_pro": prodDoc['imagen_pro'],
                          "cantidad_pro": _cantidad.text
                      }
                    );
                  showToast("El Producto ${prodDoc['nombre_pro']} se agrego al Carrito de compra", context, 
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);  
                  Navigator.of(context).pop();
                   
                  /* Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => ConfirmarDireccionYPedido(userDoc: docUsu,
                                                catGenDoc: docCatProv, proveDoc: null,
                                                catProvDoc: null, prodDoc: prodDoc,)
                                                )); */
                    
                      /* CloudFunctions.instance.call(
                        functionName: "crearPedidoUsu",
                        parameters: {
                          "doc_id": usu.uid,
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
                          "nombres": usu.displayName,
                          "correo": usu.email,
                          "telefono": userDoc.data['telefono'],
                          "nombrePizza": prodDoc['nombre_pro'],
                          "descripcion": prodDoc['descripcion_pro'],
                          "precio": prodDoc['precio_pro'],
                          "imagen": prodDoc['imagen_pro'],
                        }
                      );   *//* 
                      Navigator.of(context).pop();  */                     
                  }
                  ,)
              ],

        );
      }
    );
  }

  void showToast(String msg, BuildContext context, {int duration, int gravity}) 
  {
    Toast.show(msg, context, duration: duration, gravity: gravity);
   }
}
