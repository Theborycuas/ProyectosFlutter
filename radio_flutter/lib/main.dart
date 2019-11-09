import 'package:flutter/material.dart';
import 'package:radio_flutter/principalInterfaceRadio.dart';

void main() {
  runApp(new MaterialApp(
   home: RadioFlutter(),
  ));
}

class RadioFlutter extends StatefulWidget {
  RadioFlutter({Key key}) : super(key: key);

  _RadioFlutterState createState() => _RadioFlutterState();
}

class _RadioFlutterState extends State<RadioFlutter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Radio Flutter"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text("Ver Radio"),
              onPressed: (){
                   Navigator.push(context, MaterialPageRoute(
                              builder: (context) => RadioInterface())); 
              },
            ),
          ],
        )
      ),
    );

  }
}