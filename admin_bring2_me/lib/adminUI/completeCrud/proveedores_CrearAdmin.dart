import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class CrearProveedor extends StatefulWidget {
  const CrearProveedor({Key key, @required this.ciu, this.catGen}):super(key: key);
  final DocumentSnapshot ciu;
  final DocumentSnapshot catGen;
  @override
  _CrearProveedorState createState() => new _CrearProveedorState();
 }
  //imagen
  File image = null;
  String filename = null; //image

class _CrearProveedorState extends State<CrearProveedor> {
    TextEditingController _nombreCiudad = new TextEditingController();
    TextEditingController _nombreCategoiaGen = new TextEditingController();
    TextEditingController _nombreController = new TextEditingController();
    TextEditingController _direccionController = new TextEditingController();
    TextEditingController _telefonoControlles = new TextEditingController();

@override
  void initState() {
    // TODO: implement initState
    _nombreCiudad = TextEditingController(text: widget.ciu.data['nombre_ciu']);
    _nombreCategoiaGen = TextEditingController(text: widget.catGen.data['nombre_cat_gen']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return new Scaffold(
      appBar: AppBar(
        title: Text('CREAR UN PROVEEDOR'),
      ),
      body: Container(
        height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: ListView(
              children: <Widget>[
                TextField(
                  enabled: false,
                  controller: _nombreCiudad,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_city),
                    labelText: 'Ciudad:'
                  ),
                ),
                TextField(
                  enabled: false,
                  controller: _nombreCategoiaGen,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.panorama_wide_angle),
                    labelText: 'Categoria General:'
                  ),
                ),                
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                TextField(
                  controller: _nombreController,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.camera_front),
                    labelText: 'Nombre:'
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                TextField(
                  controller: _direccionController,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.map),
                    labelText: 'Direccion:'
                  ),
                ),
                
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                TextField(
                  controller: _telefonoControlles,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: 'Telefono'
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),                
                RaisedButton(
                  onPressed: () {
                    if(_nombreController.text != "" && _direccionController.text != "" && _telefonoControlles.text != ""){
                        CloudFunctions.instance.call(
                          functionName: "updateProveedor",
                          parameters: {
                            "doc_ciu": widget.ciu.documentID,
                            "doc_catGen": widget.catGen.documentID,
                            "nombre_prov": _nombreController.text,
                            "direccion_prov": _direccionController.text,
                            "telefono_prov": _telefonoControlles.text,
                          }
                        );
                      
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
}
