import 'package:bring2me/ui/uiAllProduct/productos/productos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaProveedoresYCartegoria extends StatefulWidget {
const ListaProveedoresYCartegoria(
      {Key key, @required this.width, this.height, this.isLargeImg = false,
       this.docProv, this.docCatGen, this.userDoc})
      : super(key: key);

  final double height;
  final double width;
  final bool isLargeImg;
  final DocumentSnapshot docProv;
  final DocumentSnapshot docCatGen;
  final DocumentSnapshot userDoc;

  _ListaProveedoresYCartegoriaState createState() => _ListaProveedoresYCartegoriaState();
}

class _ListaProveedoresYCartegoriaState extends State<ListaProveedoresYCartegoria> {
  
 @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),

          SizedBox(height: 15),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext c, BoxConstraints constr) {
                return new StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('ciudad').document("Esmeraldas").collection('categoriaGen').document(widget.docCatGen.documentID).collection('proveedor').document(widget.docProv.documentID).collection('categoria').snapshots(),      
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
                                                builder: (context) => ListProductos(catGenDoc: widget.docCatGen, 
                                                catProvDoc: catProvDoc , proveDoc: widget.docProv, userDoc: widget.userDoc,)
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
                                         
                                        
                                        ],
                                      ),
                                      InkWell(
                                          child: Icon(Icons.arrow_forward),
                                          onTap: (){
                                            print("soy un ${catProvDoc.data["nombre_cat"]}");
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => ListProductos(catGenDoc: widget.docCatGen, 
                                                catProvDoc: catProvDoc , proveDoc: widget.docProv, userDoc: widget.userDoc,)
                                              ));
                                            /* _verProductoDialog(context, catProvDoc, user); */
                                          },
                                        ),
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
}


