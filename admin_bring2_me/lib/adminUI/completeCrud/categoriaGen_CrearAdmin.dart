import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class CrearCategoriaGen extends StatefulWidget {
  const CrearCategoriaGen({Key key, @required this.ciu}): super(key:key);
  final DocumentSnapshot  ciu;
  @override
  _CrearCategoriaGenState createState() => new _CrearCategoriaGenState();
 }
  //imagen
  File image = null;
  String filename = null; //image

class _CrearCategoriaGenState extends State<CrearCategoriaGen> {

    TextEditingController _nombreCiu = new TextEditingController();
    TextEditingController _nombreController = new TextEditingController();
    TextEditingController _descripcionController = new TextEditingController();
    TextEditingController _imagen = new TextEditingController();

@override
  void initState() {
    // TODO: implement initState
    _nombreCiu = TextEditingController(text: widget.ciu.data['nombre_ciu']);
    image = null;
    filename = null;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return new Scaffold(
      appBar: AppBar(
        title: Text('CREAR CATEGORIA GENERAL'),
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
                  controller: _nombreController,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.content_paste),
                    labelText: 'Nombre Categoria General:'
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
                    CloudFunctions.instance.call(
                      functionName: "actualizarCategoriaGen",
                      parameters: {
                        "doc_ciu": widget.ciu.documentID,
                        "nombre_cat_gen": _nombreController.text,
                        "descripcion_cat_gen": _descripcionController.text,
                        "imagen_cat_gen": _imagen.text,
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