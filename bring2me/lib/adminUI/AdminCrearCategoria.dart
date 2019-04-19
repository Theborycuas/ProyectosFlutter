import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class CrearCategoria extends StatefulWidget {
  @override
  _CrearCategoriaState createState() => new _CrearCategoriaState();
 }
  //imagen
  File image = null;
  String filename = null; //image

class _CrearCategoriaState extends State<CrearCategoria> {

    TextEditingController _nombreController = new TextEditingController();
    TextEditingController _descripcionController = new TextEditingController();
    TextEditingController _precioControlles = new TextEditingController();
    TextEditingController _imagen = new TextEditingController();


  @override
  Widget build(BuildContext context) {
  return new Scaffold(
      appBar: AppBar(
        title: Text('CREAR PIZZAS'),
      ),
      body: Container(
        height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: ListView(
              children: <Widget>[
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
                      functionName: "crearCategoria",
                      parameters: {
                        "doc_id":_nombreController.text,
                        "nombre_cat": _nombreController.text,
                        "descripcion_cat": _descripcionController.text,
                        "imagen_cat": _imagen.text,
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
        ),

      ),
      
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

}//i

  
}
