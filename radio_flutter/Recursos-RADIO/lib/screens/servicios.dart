import 'package:flutter/material.dart';
import 'package:lipsum/lipsum.dart' as lipsum;

class Servicioswidget extends StatefulWidget {
  Servicioswidget({Key key}) : super(key: key);

  _ServicioswidgetState createState() => _ServicioswidgetState();
}

class Servicio {
  final String nombre;
  final String descripcion;

  Servicio({this.nombre, this.descripcion});
}

class _ServicioswidgetState extends State<Servicioswidget> {
  List<Servicio> _servicios = [
    Servicio(
      nombre: 'Servicio1',
      descripcion: lipsum.createSentence(),
    ),
    Servicio(
      nombre: 'Servicio2',
      descripcion: lipsum.createSentence(),
    ),
    Servicio(
      nombre: 'Servicio3',
      descripcion: lipsum.createSentence(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Servicios"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListView.builder(
                itemCount: _servicios.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            _servicios[index].nombre,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   height: 180,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(8.0),
                        //     child: FadeInImage(
                        //       image: NetworkImage(_servicios[index].link),
                        //       fit: BoxFit.cover,
                        //       placeholder:
                        //           AssetImage('assets/images/loader.gif'),
                        //     ),
                        //   ),
                        // ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              _servicios[index].descripcion,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: RaisedButton(
                              // color: Color.fromRGBO(218, 25, 33, 1),
                              color: Colors.white,
                              onPressed: () {
                                print('Contratar al ws');
                              },
                              child: Text('Contratar'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Container(
                            height: 1.5,
                            color: Colors.white24,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
