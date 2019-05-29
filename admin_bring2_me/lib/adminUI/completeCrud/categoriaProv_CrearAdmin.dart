import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class CrearCategoria extends StatefulWidget {
  const CrearCategoria({Key key, @required this.ciu, this.prov, this.catGen}): super(key:key);
  final DocumentSnapshot  ciu;
  final DocumentSnapshot catGen;
  final DocumentSnapshot prov;
  @override
  _CrearCategoriaState createState() => new _CrearCategoriaState();
 }
  //imagen
  File image = null;
  String filename = null; //image

class _CrearCategoriaState extends State<CrearCategoria> {

    TextEditingController _nombreCiu = new TextEditingController();
    TextEditingController _nombreProv = new TextEditingController();
    TextEditingController _nombreCatGen = new TextEditingController();
    TextEditingController _nombreController = new TextEditingController();
    TextEditingController _descripcionController = new TextEditingController();
    TextEditingController _imagen = new TextEditingController();
    bool imagensubida = false;

@override
  void initState() {
    // TODO: implement initState
    _nombreCiu = TextEditingController(text: widget.ciu.data['nombre_ciu']);
    _nombreProv = TextEditingController(text: widget.prov.data['nombre_prov']);
    _nombreCatGen = TextEditingController(text: widget.catGen.data['nombre_cat_gen']);
    image = null;
    filename = null; 
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return new Scaffold(
      appBar: AppBar(
        title: Text('CREAR CATEGORIA'),
      ),
      body: Container(
        height: 670.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          
          child: Center(
            child: ListView(
              children: <Widget>[
                TextField(
                  controller: _nombreCiu,
                  enabled: false,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_city),
                    labelText: 'Nombre Ciudad:'
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                TextField(
                  controller: _nombreCatGen,
                  enabled: false,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.camera_front),
                    labelText: 'Nombre Categoria General:'
                  ),
                ),                
                TextField(
                  controller: _nombreProv,
                  enabled: false,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.camera_front),
                    labelText: 'Nombre Proveedor:'
                  ),
                ),
                
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                TextField(
                  controller: _nombreController,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.content_paste),
                    labelText: 'Nombre Categoria:'
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
                  enabled: false,
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
                    if(_nombreController.text != "" && _descripcionController.text != "" && imagensubida != false){
                        CloudFunctions.instance.call(
                          functionName: "updateCategoria",
                          parameters: {
                            "doc_ciu": widget.ciu.documentID,
                            "doc_catGen": widget.catGen.documentID,
                            "doc_prov": widget.prov.documentID,
                            "nombre_cat": _nombreController.text,
                            "descripcion_cat": _descripcionController.text,
                            "imagen_cat": _imagen.text,
                          }
                        );
                      
                        image = null;
                        Navigator.of(context).pop();
                    }
                    else{                           
                        print('no actions');
                        showToast("INGRESE LA INFORMACION COMPLETA", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);  
                    }                        

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
void showToast(String msg, BuildContext context, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
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
        imagensubida = true;
    });

  return url;

}//i

  
}
