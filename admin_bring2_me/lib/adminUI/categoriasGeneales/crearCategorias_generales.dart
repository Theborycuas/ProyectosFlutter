import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class CrearCategoriasGenerales extends StatefulWidget {

  @override
  _CrearCategoriasGeneralesState createState() => new _CrearCategoriasGeneralesState();
 }
 //imagen
  File image = null;
  String filename = null; //image
class _CrearCategoriasGeneralesState extends State<CrearCategoriasGenerales> {

    TextEditingController _nombreCategoriaController = TextEditingController();
    TextEditingController _descripcionController = new TextEditingController();
    TextEditingController _imagenController = new TextEditingController();
    bool imagensubida = false;

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
        _imagenController = TextEditingController(text: url);
        imagensubida = true;

    });

  return url;

}//imagen

 
 StreamBuilder<QuerySnapshot> _recuperarCategoria(){
   
    return StreamBuilder<QuerySnapshot>(  
    stream: Firestore.instance.collection('categoria').snapshots(), 
    
    builder: (context, snapshot) {
      if (!snapshot.hasData && !snapshot.hasError)
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
                          controller: _nombreCategoriaController,
                          style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                          decoration: InputDecoration(
                            icon: Icon(Icons.drag_handle),
                            labelText: 'Nombre Caregoria:'
                          ),
                        ),
                        Divider(),                                        
                       TextField(
                          controller: _descripcionController,
                          style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                          decoration: InputDecoration(
                            icon: Icon(Icons.description),
                            labelText: 'Descripcion Categoria:'
                          ),
                        ),
                       
                        Padding(padding: EdgeInsets.only(top: 8.0),),
                        Divider(),
                        TextField(
                          enabled: false,
                          controller: _imagenController,
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
                            if(imagensubida != false && _nombreCategoriaController != null 
                             && _descripcionController != null){
                                  CloudFunctions.instance.call(
                                    functionName: "crearCategoriaGeneral",
                                    parameters: {
                                      "nombre_cat_gen": _nombreCategoriaController.text,
                                      "descripcion_cat_gen": _descripcionController.text,
                                      "imagen_cat_gen": _imagenController.text,
                                    }
                                  );
                                  image = null;
                                  Navigator.of(context).pop();                              
                            }
                            else{
                              
                              print('no actions');
                              showToast("INGRESE LA INFORMACION COMPLETA", context,
                                 duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);  
                            }
                          },
                          child: const Text("Guardar Producto")
                      )  
              ],
            ),
          ),
        )
      );
    });
} 
  void showToast(String msg, BuildContext context, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  
  void _onShopDropItemSelected(String newValueSelected) {
    setState(() {
      this.shopId = newValueSelected;
    });
  }


}
