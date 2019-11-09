import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class CrearProducto extends StatefulWidget {

  @override
  _CrearProductoState createState() => new _CrearProductoState();
 }
 //imagen
  File image = null;
  String filename = null; //image
class _CrearProductoState extends State<CrearProducto> {

    TextEditingController _nombreController = new TextEditingController();
    TextEditingController _descripcionController = new TextEditingController();
    TextEditingController _precioControlles = new TextEditingController();
    TextEditingController _imagen = new TextEditingController();
    bool imagensubida = false;

  String shopId;


  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: AppBar(
       title: Text('CREAR PRODUCTOS'),
     ),
     body: Container(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Card(
          child: Center(
            child: ListView(
              children: <Widget>[                 
                  
                SizedBox(height: 5.0,),                      
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
                            if(imagensubida != false || _nombreController == null || _descripcionController == null
                            || _precioControlles == null){
                                 /*  CloudFunctions.instance.call(
                                    functionName: "actualizarProducto",
                                    parameters: {
                                   /*    "doc_ciu": widget.ciu.documentID,
                                      "doc_catGen": widget.catGen.documentID,                                     
                                      "doc_prov": widget.prove.documentID,
                                      "doc_cat": widget.cat.documentID, */
                                      "nombre_pro": _nombreController.text,
                                      "descripcion_pro": _descripcionController.text,
                                      "precio_pro": _precioControlles.text,
                                      "imagen_pro": _imagen.text,
                                    }
                                  ); */
                                  image = null;
                                  Navigator.of(context).pop();                              
                            }
                            else{
                              
                              print('no actions');
                              showToast("INGRESE LA INFORMACION COMPLETA", context,
                                 duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);  
                            }
                          },
                          child: const Text("Guardar Producto")
                      )  
              ],
            ),
          ),
        )
      )
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
        imagensubida = true;

    });

  return url;

}//imagen
 
  void showToast(String msg, BuildContext context, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  
}
 */