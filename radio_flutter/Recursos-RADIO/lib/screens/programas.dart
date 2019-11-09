import 'package:flutter/material.dart';
import 'package:lipsum/lipsum.dart' as lipsum;

class Programaswidget extends StatefulWidget {
  Programaswidget({Key key}) : super(key: key);

  _ProgramaswidgetState createState() => _ProgramaswidgetState();
}

class Programa {
  final String nombre;
  final String link;
  final String descripcion;

  Programa({this.nombre, this.link, this.descripcion});
}

class _ProgramaswidgetState extends State<Programaswidget> {
  List<Programa> _programas = [
    Programa(
      nombre: 'Programa1',
      link:
          'https://images.pexels.com/photos/990826/pexels-photo-990826.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      descripcion: lipsum.createSentence(),
    ),
    Programa(
      nombre: 'Programa2',
      link:
          'https://images.pexels.com/photos/1227497/pexels-photo-1227497.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      descripcion: lipsum.createSentence(),
    ),
    Programa(
      nombre: 'Programa3',
      link:
          'https://images.pexels.com/photos/1493378/pexels-photo-1493378.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
      descripcion: lipsum.createSentence(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Programas"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListView.builder(
                itemCount: _programas.length,
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
                            _programas[index].nombre,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage(
                              image: NetworkImage(_programas[index].link),
                              fit: BoxFit.cover,
                              placeholder:
                                  AssetImage('assets/images/loader.gif'),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              _programas[index].descripcion,
                              style: TextStyle(color: Colors.white),
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
