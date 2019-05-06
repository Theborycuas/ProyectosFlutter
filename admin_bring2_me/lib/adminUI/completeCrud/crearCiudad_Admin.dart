import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class CrearCiudad extends StatefulWidget {
  @override
  _CrearCiudadState createState() => new _CrearCiudadState();
 }
  //imagen
  File image = null;
  String filename = null; //image

class _CrearCiudadState extends State<CrearCiudad> {

    TextEditingController _nombreController = new TextEditingController();
    TextEditingController _direccion_oficina = new TextEditingController();


  @override
  Widget build(BuildContext context) {
  return new Scaffold(
      appBar: AppBar(
        title: Text('CREAR CIUDADES'),
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
                  controller: _direccion_oficina,
                  style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                    icon: Icon(Icons.list),
                    labelText: 'Direccion de Oficinas:'
                  ),
                ),              
                
                RaisedButton(
                  onPressed: () {
                    CloudFunctions.instance.call(
                      functionName: "crearCiudad",
                      parameters: {
                        "doc_id":_nombreController.text,
                        "nombre_ciu": _nombreController.text,
                        "direccion_oficina": _direccion_oficina.text,
                      }
                    );
                   
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
}
