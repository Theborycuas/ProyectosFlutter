import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CrearProducto extends StatefulWidget {
  const CrearProducto({Key key, this.ciu, this.prove, this.cat}) : super(key:key);
  final DocumentSnapshot ciu;
  final DocumentSnapshot prove;
  final DocumentSnapshot cat;
  @override
  _CrearProductoState createState() => new _CrearProductoState();
 }
 //imagen
  File image = null;
  String filename = null; //image
class _CrearProductoState extends State<CrearProducto> {

    TextEditingController _nombreCiudad = TextEditingController();
    TextEditingController _nombreProveedor = TextEditingController();
    TextEditingController _nombreCategoria = TextEditingController();
    TextEditingController _nombreController = new TextEditingController();
    TextEditingController _descripcionController = new TextEditingController();
    TextEditingController _precioControlles = new TextEditingController();
    TextEditingController _imagen = new TextEditingController();

  String shopId;

  @override
  void initState() {
    // TODO: implement initState
    _nombreCiudad = TextEditingController(text: widget.ciu.data["nombre_ciu"]);
    _nombreProveedor = TextEditingController(text: widget.prove.data["nombre_prov"]);
    _nombreCategoria = TextEditingController(text: widget.cat.data["nombre_cat"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: Text('CREAR PRODUCTOS'),
     ),
     body: _recuperarCategoria()    
   );
  }

 //Seleccionar imagen o tmar foto. 
  Future _getImage() async{
    var selectedImage =await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
    image = selectedImage;
    filename = basename(image.path);
    uploadArea();
    uploadImage();
    });

}//imagen
  //imagen
  Widget uploadArea(){
    
  return Column(
    children: <Widget>[
      Image.file(image, width: 50.0),             
    ],
  );
}

Future<String> uploadImage ()async{
  StorageReference ref = FirebaseStorage.instance.ref().child(filename);
  StorageUploadTask uploadTask = ref.putFile(image);

  var downUrl =await (await uploadTask.onComplete).ref.getDownloadURL();
  var url = downUrl.toString(); 
    setState(() { 
        _imagen = TextEditingController(text: url);
    });

  return url;

}//imagen

 
 StreamBuilder<QuerySnapshot> _recuperarCategoria(){
   
    return StreamBuilder<QuerySnapshot>(  
    stream: Firestore.instance.collection('categoria').snapshots(), 
    
    builder: (context, snapshot) {
      if (!snapshot.hasData)
        return Center(
          child: CupertinoActivityIndicator(),
        );

      return Container(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Card(
          child: Center(
            child: ListView(
              children: <Widget>[                  
                    /* DropdownButton(
                        value: shopId,
                        isDense: true,
                        onChanged: (valueSelectedByUser) {
                          _onShopDropItemSelected(valueSelectedByUser);
                          
                        },
                        hint: Text('           SELECCIONE UNA CATEGORIA'),
                        items: snapshot.data.documents
                            .map((final DocumentSnapshot document) {
                          return DropdownMenuItem<String>(
                            value: document.documentID,
                            child: Text(document.data['nombre_cat']),
                          );
                          

                        }).toList(),
                      ), */
                SizedBox(height: 5.0,),                      
                       TextField(
                         enabled: false,
                          controller: _nombreCiudad,
                          style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                          decoration: InputDecoration(
                            icon: Icon(Icons.location_city),
                            labelText: 'Ciudad:'
                          ),
                        ),
                        Divider(),                                        
                       TextField(
                         enabled: false,
                          controller: _nombreProveedor,
                          style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                          decoration: InputDecoration(
                            icon: Icon(Icons.camera_front),
                            labelText: 'Proveedor:'
                          ),
                        ),
                       
                        Divider(),                     
                       TextField(
                         enabled: false,
                          controller: _nombreCategoria,
                          style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                          decoration: InputDecoration(
                            icon: Icon(Icons.content_paste),
                            labelText: 'Categoria:'
                          ),
                        ),                        
                        Divider(),
                       TextField(
                          controller: _nombreController,
                          style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                          decoration: InputDecoration(
                            icon: Icon(Icons.select_all),
                            labelText: 'Nombre:'
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0),),
                        Divider(),
                        TextField(
                          controller: _descripcionController,
                          style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                          decoration: InputDecoration(
                            icon: Icon(Icons.list),
                            labelText: 'Descripcion:'
                          ),
                        ),
                         Padding(padding: EdgeInsets.only(top: 8.0),),
                          Divider(),
                          TextField(
                            controller: _precioControlles,
                            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                            decoration: InputDecoration(
                              icon: Icon(Icons.monetization_on),
                              labelText: 'Precio'
                            ),
                          ),
                        Padding(padding: EdgeInsets.only(top: 8.0),),
                        Divider(),
                        TextField(
                          controller: _imagen,
                          style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                          decoration: InputDecoration(
                            icon: Icon(Icons.image),
                            labelText: 'Imagen'
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0),),

                          Padding(padding: EdgeInsets.only(top: 15.0),),
                          FlatButton(
                            child: image==null?Image.asset("assets/images/galeria.png",width: 75.0,): uploadArea(),
                            onPressed: (){
                                    _getImage();
                            },
                          ),
                          SizedBox(                          
                                    width: 150.0,
                                    height: 50.0,
                                  
                                    child: image==null?Text("                         Seleccione una imagen"):Text(""),      
                            ),//imagen
                          Divider(),
                        RaisedButton(
                          onPressed: () {
                            CloudFunctions.instance.call(
                              functionName: "crearProducto",
                              parameters: {
                                "doc_ciu": widget.ciu.documentID,
                                "doc_prov": widget.prove.documentID,
                                "doc_cat": widget.cat.documentID,
                                "nombre_pro": _nombreController.text,
                                "descripcion_pro": _descripcionController.text,
                                "precio_pro": _precioControlles.text,
                                "imagen_pro": _imagen.text,
                              }
                            );
                            image = null;
                            Navigator.of(context).pop();
                          },
                          child: const Text("Guardar")
                      )  
              ],
            ),
          ),
        )
      );
    });
} 
void _onShopDropItemSelected(String newValueSelected) {
    setState(() {
      this.shopId = newValueSelected;
    });
  }
}
