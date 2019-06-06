import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfirmarDireccionYPedido extends StatefulWidget {
    const ConfirmarDireccionYPedido({Key key, @required this.catGenDoc, this.proveDoc, 
    this.catProvDoc, this.userDoc, this.prodDoc }) : super(key: key); 
  final DocumentSnapshot userDoc;  
  final DocumentSnapshot catGenDoc;
  final DocumentSnapshot proveDoc;
  final DocumentSnapshot catProvDoc;
  final DocumentSnapshot prodDoc;


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
        content: bodyConfirmarPedido(widget.userDoc, widget.prodDoc),
      ),
      Step(
        title: Text('Paso 2'),
        isActive: _currentStep >= 1,
        content: TextField(),
      ),
      Step(
        title: Text('Paso 3'),
        isActive: _currentStep >= 2,
        content: TextField(),
      )
    ];
    return _steps;
  }
  Widget bodyConfirmarPedido(DocumentSnapshot docUsu, DocumentSnapshot docProd) {
    TextEditingController _nombreController = new TextEditingController(text: docProd['nombre_pro']);
    TextEditingController _descripcionController = new TextEditingController(text: docProd['descripcion_pro']);
    TextEditingController _precioControlles = new TextEditingController(text: docProd['precio_pro']);
    
   return Container(
       height: 570.0,
          child: Center(            
           child: Column(
             children: <Widget>[
               Text("PRODUCTOS", style: TextStyle(fontSize: 20.0),),
               Row(
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
               Text("DIRECCIÓN", style: TextStyle(fontSize: 20.0),),
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
               Text("TELEFONO", style: TextStyle(fontSize: 20.0),),
               Row(
                 children: <Widget>[

                   Expanded(
                     child: ListTile(
                       title: new Text("0996588558"),
                        subtitle: new Text(""),
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
  
}