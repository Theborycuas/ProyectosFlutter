import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:dropdown_menu/dropdown_menu.dart';

class ProductScreenPizzas extends StatefulWidget {
  @override
  _ProductScreenPizzasState createState() => new _ProductScreenPizzasState();
 }
 //imagen
  File image = null;
  String filename = null; //image
class _ProductScreenPizzasState extends State<ProductScreenPizzas> {

    TextEditingController _nombreController = new TextEditingController();
    TextEditingController _descripcionController = new TextEditingController();
    TextEditingController _precioControlles = new TextEditingController();
    TextEditingController _imagen = new TextEditingController();

  String shopId;

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
                SizedBox(height: 30.0,),
                DropdownButton(
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
                      ),
                      SizedBox(height: 10.0,),                      
                       TextField(
                          controller: _nombreController,
                          style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                          decoration: InputDecoration(
                            icon: Icon(Icons.create),
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
                                "doc_id": shopId,
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


