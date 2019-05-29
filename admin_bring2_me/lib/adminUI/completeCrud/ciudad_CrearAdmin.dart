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
                    if(_nombreController.text != "" && _direccion_oficina.text != ""){
                          int ciudad = 0;
                          while(ciudad == 0){
                              CloudFunctions.instance.call(
                              functionName: "updateCiudad",
                              parameters: {                        
                                "nombre_ciu": _nombreController.text,
                                "direccion_oficina": _direccion_oficina.text,
                              }
                            );
                            ciudad = ciudad + 1;
                          }
                          CloudFunctions.instance.call(
                            functionName: "actualizarCategoriaGen",
                            parameters: {
                              "doc_ciu": _nombreController.text,
                              "nombre_cat_gen": "ALCOHOL",
                              "descripcion_cat_gen": "Encuentra todo tipo de bebidas alcohólicas",
                              "imagen_cat_gen": "https://firebasestorage.googleapis.com/v0/b/bring2me-e3467.appspot.com/o/received_500982320433928.png?alt=media&token=999efbb1-95f9-401e-8169-92217e9e9b86",
                            }
                          );
                          CloudFunctions.instance.call(
                            functionName: "actualizarCategoriaGen",
                            parameters: {
                              "doc_ciu": _nombreController.text,
                              "nombre_cat_gen": "COMIDA",
                              "descripcion_cat_gen": "Disfruta de la mejor comida de tu ciudad",
                              "imagen_cat_gen": "https://firebasestorage.googleapis.com/v0/b/bring2me-e3467.appspot.com/o/received_266518974293871.png?alt=media&token=04a4afcb-d55d-442f-af54-7d7aed254ff2",
                            }
                          );
                          CloudFunctions.instance.call(
                            functionName: "actualizarCategoriaGen",
                            parameters: {
                              "doc_ciu": _nombreController.text,
                              "nombre_cat_gen": "CUALQUIER COSAS",
                              "descripcion_cat_gen": "Pide lo que desees, nosotros te lo llevamos",
                              "imagen_cat_gen": "https://firebasestorage.googleapis.com/v0/b/bring2me-e3467.appspot.com/o/received_2269450136707971.png?alt=media&token=c476ae26-5c82-43de-a8a8-16be0355bc54",
                            }
                          );
                          CloudFunctions.instance.call(
                            functionName: "actualizarCategoriaGen",
                            parameters: {
                              "doc_ciu": _nombreController.text,
                              "nombre_cat_gen": "ENCOMIENDAS",
                              "descripcion_cat_gen": "Se realizan todo tipo de encomiendas en tu ciudad",
                              "imagen_cat_gen": "https://firebasestorage.googleapis.com/v0/b/bring2me-e3467.appspot.com/o/received_1591332237666049.png?alt=media&token=7a030b2e-bfc1-4393-89a2-1fe8b661d098",
                            }
                          );
                          CloudFunctions.instance.call(
                            functionName: "actualizarCategoriaGen",
                            parameters: {
                              "doc_ciu": _nombreController.text,
                              "nombre_cat_gen": "FARMACIA",
                              "descripcion_cat_gen": "Encuentra las mejores Farmacias de tu ciudad",
                              "imagen_cat_gen": "https://firebasestorage.googleapis.com/v0/b/bring2me-e3467.appspot.com/o/received_367174163892016.png?alt=media&token=752b62b0-0e2e-42d1-aba2-e990fe5db9e2",
                            }
                          );
                          CloudFunctions.instance.call(
                            functionName: "actualizarCategoriaGen",
                            parameters: {
                              "doc_ciu": _nombreController.text,
                              "nombre_cat_gen": "REGALOS",
                              "descripcion_cat_gen": "Puedes encontrar los mejores presentes y regalos de tu ciudad",
                              "imagen_cat_gen": "https://firebasestorage.googleapis.com/v0/b/bring2me-e3467.appspot.com/o/received_984867471721854.png?alt=media&token=40d8ebcf-cf69-41ce-89ca-b3e29384d5da",
                            }
                          );
                          CloudFunctions.instance.call(
                            functionName: "actualizarCategoriaGen",
                            parameters: {
                              "doc_ciu": _nombreController.text,
                              "nombre_cat_gen": "SNACKS",
                              "descripcion_cat_gen": "Deliciosos y de todo tipo de Snacks para ti",
                              "imagen_cat_gen": "https://firebasestorage.googleapis.com/v0/b/bring2me-e3467.appspot.com/o/received_323750941676661.png?alt=media&token=c5ec57ea-be7c-413c-8e95-312f1ee10ad5",
                            }
                          );                                                                                                                                            
                          CloudFunctions.instance.call(
                            functionName: "actualizarCategoriaGen",
                            parameters: {
                              "doc_ciu": _nombreController.text,
                              "nombre_cat_gen": "SUPERMERCADO",
                              "descripcion_cat_gen": "Se realizan las compras de cualquier supermercado",
                              "imagen_cat_gen": "https://firebasestorage.googleapis.com/v0/b/bring2me-e3467.appspot.com/o/received_862330444128250.png?alt=media&token=dfd44cba-cafd-4e7d-940d-dfa6de8e56e3",
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
