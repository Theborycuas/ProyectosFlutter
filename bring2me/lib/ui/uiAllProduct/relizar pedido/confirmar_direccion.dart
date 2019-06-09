import 'package:bring2me/ui/uiAllProduct/productHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmarDireccionYPedido extends StatefulWidget {
  const ConfirmarDireccionYPedido({Key key, @required this.userDoc,}) : super(key: key); 
  final DocumentSnapshot userDoc;  


  @override
  _ConfirmarDireccionYPedidoState createState() => new _ConfirmarDireccionYPedidoState();
}

class _ConfirmarDireccionYPedidoState extends State<ConfirmarDireccionYPedido> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("CONFIRMAR PEDIDO"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Stepper(
        steps: _mySteps(),
        type: StepperType.horizontal,
        currentStep: this._currentStep,
        onStepTapped: (step){
          setState(() {
            this._currentStep = step;
          });
        },
        onStepContinue: (){
          setState(() {
            if(this._currentStep < this._mySteps().length - 1){
              this._currentStep = this._currentStep + 1;
            }else{
              //Logic to check if everything is completed
              print('Completed, check fields.');
            }
          });
        },
        onStepCancel: () {
          
          setState(() {
            if(this._currentStep > 0){
              this._currentStep = this._currentStep - 1;
            }else{
              this._currentStep = 0;
            }
          });
        },
      ),
    );
  }

  List<Step> _mySteps(){
    List<Step> _steps = [
      Step(
        title: Text('Paso 1'),        
        isActive: _currentStep >= 0,
        content: bodyConfirmarPedidoPrimero(widget.userDoc),
      ),
      Step(
        title: Text('Paso 2'),
        isActive: _currentStep >= 1,
        content: bodyConfirmarPedidoSegudo(widget.userDoc),
      ),
      Step(
        title: Text('Paso 3'),
        isActive: _currentStep >= 2,
        content: bodyConfirmarPedidoTercero(widget.userDoc),
      )
    ];
    return _steps;
  }

  Widget bodyConfirmarPedidoPrimero(DocumentSnapshot docUsu) {
   
    
   return Container(
       height: 600.0,
          child: Center(            
           child: Column(
             children: <Widget>[
               Text("DATOS DE PRODUCTO/S", style: TextStyle(fontSize: 20.0),),
               SizedBox(
                 height: 150.0,
                 width: 500.0,
                 child:  _recuperarPrePedidos(),
               ),
                IconButton(
                      icon: Icon(Icons.plus_one),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => ProductHomePage(docUsu: widget.userDoc,)
                                        ));
                      },
                    ),
               Padding(padding: EdgeInsets.only(top: 15.0),),
               Divider(),
               Text("DATOS DE USUARIO/S", style: TextStyle(fontSize: 20.0),),
               Row(
                 children: <Widget>[

                    Expanded(
                     child: ListTile(
                       title: new Text(docUsu['nombres']),
                        subtitle: new Text(docUsu['correo']),
                        leading: Column(
                        children: <Widget>[
                          Image.network('${docUsu['foto']}', width: 40),
                          ],
                       ),
                    ),
                   
                   ), 
                   Column(
                     children: <Widget>[
                       IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){

                      },
                    ),
                     ],
                   )
                    
                 ],
               ), 
               Padding(padding: EdgeInsets.only(top: 8.0),),
               Divider(),
               Text("DATOS DE DIRECCIÓN", style: TextStyle(fontSize: 20.0),),
               Row(
                 children: <Widget>[

                   Expanded(
                     child: ListTile(
                       title: new Text("Esmeraldas"),
                        subtitle: new Text("Sucre y Montalvo"),
                        leading: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.location_on),
                            onPressed: (){},
                          )
                          ],
                       ),
                    ),
                   
                   ),
                   Column(
                     children: <Widget>[
                       IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){

                      },
                    ),
                     ],
                   )
                    
                 ],
               ),
                Divider(), 
               Text("DATOS DE CONTACTO", style: TextStyle(fontSize: 20.0),),
               Row(
                 children: <Widget>[

                   Expanded(
                     child: ListTile(
                       title: new Text("Telefono"),
                        subtitle: new Text('0996588558', style: TextStyle(fontSize: 20),),
                        leading: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.phone),
                            onPressed: (){},
                          )
                          ],
                       ),
                    ),
                   
                   ),
                   Column(
                     children: <Widget>[
                       IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){

                      },
                    ),
                     ],
                   )
                    
                 ],
               ),
                    
                    Divider(), 
               
               
             ],
           ),
         ),

     );
  }

  StreamBuilder<QuerySnapshot> _recuperarPrePedidos() {
  
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('usuarios').document(widget.userDoc.documentID).collection('prePedidosUsu').snapshots(),      
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        
          if (!snapshot.hasData || snapshot.data == null) {
            //print(logger);
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 45.0,),
                  Text('Cargando Productos...'),
                  SizedBox(height: 15.0,),
                  CupertinoActivityIndicator(            
                        ),
                ],
              ),
                
             );
          }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                  final prePedDoc = snapshot.data.documents[index];
                  TextEditingController _cantidad = TextEditingController(text: prePedDoc['cantidad_pro']);
                  return InkWell(
                       onTap:() { 
                       },
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: ListTile(
                                      title: new Text(prePedDoc['nombre_pro']),
                                      subtitle: new Text(prePedDoc['descripcion_pro']),
                                      leading: Column(
                                      children: <Widget>[
                                        Image.network('${prePedDoc['imagen_pro']}', width: 40),
                                      ],
                                    ),
                                 ),
                               ),  
                               SizedBox(
                                 width: 50.0,
                                  child: Column(
                                  children: <Widget>[                                    
                                    TextField(
                                      controller: _cantidad,
                                      decoration: InputDecoration(
                                        labelText: "Cant."
                                      ),
                                    )
                                    
                                  ],
                                ),
                               ),  
                               SizedBox(
                                 width: 50.0,
                                  child: Column(
                                  children: <Widget>[        
                                    Text("Prec."),
                                    Text('\$ ${prePedDoc['precio_pro']}'),
                                                                       
                                  ],
                                ),
                               ),                                                     
                             ],                             
                           ),
                         ],                         
                       )                    
                  );
              }
          );

        }
    );
  }

  Widget bodyConfirmarPedidoSegudo(DocumentSnapshot docUsu) {
    num _subtotal;
    num _cantidad;
    num _precio;
    num _total = 0;

   return Container(
       height: 500.0,
          child: Center(            
           child: Column(
             children: <Widget>[
               Text("DETALLE DE PEDIDO", style: TextStyle(fontSize: 20.0),),
               SizedBox(height: 30.0),
               Text("Cant.       Producto                        Precio      Subtotal",),
               SizedBox(height: 20.0),
               SizedBox(
                 height: 400.0,
                 width: 500.0,
                 child: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('usuarios').document(widget.userDoc.documentID).collection('prePedidosUsu').snapshots(),      
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          
                            if (!snapshot.hasData || snapshot.data == null) {
                              //print(logger);
                              return Center(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 45.0,),
                                    Text('Cargando Productos...'),
                                    SizedBox(height: 15.0,),
                                    CupertinoActivityIndicator(            
                                          ),
                                  ],
                                ),
                                  
                              );
                            }
                            return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {

                                   final prePedDoc = snapshot.data.documents[index];
                                    
                                   _cantidad = int.parse(prePedDoc['cantidad_pro']);                                   
                                   _precio = int.parse(prePedDoc['precio_pro']);
                                    _subtotal = _cantidad *_precio; 
                                     _total += _subtotal;
                                     print('total ${_total}');
                                    
                                    return InkWell(
                                        onTap:() { 
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 45,
                                                  width: 25,
                                                  child: Text('${prePedDoc['cantidad_pro']}'),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 45.0,
                                                    width: 30.0,
                                                    child: Text('${prePedDoc['nombre_pro']}'),
                                                  ),
                                                     
                                                ),  
                                                SizedBox(
                                                  width: 50.0,
                                                    child: Column(
                                                    children: <Widget>[      
                                                      Text('\$ ${prePedDoc['precio_pro']}'),
                                                                                        
                                                    ],
                                                  ),
                                                ),  
                                                SizedBox(
                                                  width: 50.0,
                                                    child: Column(
                                                    children: <Widget>[   
                                                       Text('\$ ${_subtotal.toString()}'), 
                                                                                        
                                                    ],
                                                  ),
                                                ),                                                     
                                              ],                             
                                            ),
                                          ],                         
                                        )                    
                                    );
                                }
                            );
                          }
                      )
               ),               
             ],
           ),
         ),

     );
  }
  
  Widget bodyConfirmarPedidoTercero(DocumentSnapshot docUsu) {
    
   return Container(
       height: 490.0,
          child: Center(            
           child: Column(
             children: <Widget>[
               Text("CONFIRMAR PEDIDO", style: TextStyle(fontSize: 20.0),),
               /* Row(
                 children: <Widget>[

                   Expanded(
                     child: ListTile(
                       title: new Text(docProd['nombre_pro']),
                        subtitle: new Text(docProd['descripcion_pro']),
                        leading: Column(
                        children: <Widget>[
                          Image.network('${docProd['imagen_pro']}', width: 40),
                          ],
                       ),
                    ),
                   
                   ),
                   Column(
                     children: <Widget>[
                       
                       Text('\$ ${docProd['precio_pro']}', style: TextStyle(fontSize: 15),),
                       IconButton(
                      icon: Icon(Icons.plus_one),
                      onPressed: (){

                      },
                    ),
                     ],
                   )
                    
                 ],
               ),
               Padding(padding: EdgeInsets.only(top: 8.0),),
               Divider(),
               Text("DATOS DE USUARIO/S", style: TextStyle(fontSize: 20.0),),
               Row(
                 children: <Widget>[

                   Expanded(
                     child: ListTile(
                       title: new Text(docUsu['nombres']),
                        subtitle: new Text(docUsu['correo']),
                        leading: Column(
                        children: <Widget>[
                          Image.network('${docUsu['foto']}', width: 40),
                          ],
                       ),
                    ),
                   
                   ),
                   Column(
                     children: <Widget>[
                       IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){

                      },
                    ),
                     ],
                   )
                    
                 ],
               ),
               Padding(padding: EdgeInsets.only(top: 8.0),),
               Divider(),
               Text("DATOS DE DIRECCIÓN", style: TextStyle(fontSize: 20.0),),
               Row(
                 children: <Widget>[

                   Expanded(
                     child: ListTile(
                       title: new Text("Esmeraldas"),
                        subtitle: new Text("Sucre y Montalvo"),
                        leading: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.location_on),
                            onPressed: (){},
                          )
                          ],
                       ),
                    ),
                   
                   ),
                   Column(
                     children: <Widget>[
                       IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){

                      },
                    ),
                     ],
                   )
                    
                 ],
               ),
                Divider(), 
               Text("DATOS DE CONTACTO", style: TextStyle(fontSize: 20.0),),
               Row(
                 children: <Widget>[

                   Expanded(
                     child: ListTile(
                       title: new Text("Telefono"),
                        subtitle: new Text("0996588558", style: TextStyle(fontSize: 20),),
                        leading: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.phone),
                            onPressed: (){},
                          )
                          ],
                       ),
                    ),
                   
                   ),
                   Column(
                     children: <Widget>[
                       IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){

                      },
                    ),
                     ],
                   )
                    
                 ],
               ), */
                    
                    Divider(), 
               
               
             ],
           ),
         ),

     );
  }
}