import 'package:flutter/material.dart';

class Concursowidget extends StatefulWidget {
  Concursowidget({Key key}) : super(key: key);

  ConcursowidgetState createState() => ConcursowidgetState();
}

class Concurso {
  final String nombre;
  final String link;
  final String descripcion;

  Concurso({this.nombre, this.link, this.descripcion});
}

class ConcursowidgetState extends State<Concursowidget> {
  final _formKey = GlobalKey<FormState>();
  final _concurso = Concurso(
      nombre: 'Concurso de Septiembre',
      link:
          'https://images.unsplash.com/photo-1553695750-ad0b596c4f80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1440&q=80',
      descripcion:
          'Descripción del concurso: inscripción válida desde el 01 sep al 30 sep');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Concurso"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 40.0, right: 40.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  _concurso.nombre,
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
                    image: NetworkImage(_concurso.link),
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/images/loader.gif'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    _concurso.descripcion,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: _inputDecoration('Nombre'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: _inputDecoration('Apellido'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su apellido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: _inputDecoration('Teléfono'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su teléfono';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: _inputDecoration('Correo'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su correo';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.0),
                child: RaisedButton(
                  // color: Color.fromRGBO(218, 25, 33, 1),
                  color: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      print('Vamo ahí');
                    }
                  },
                  child: Text('Concursa!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String _label) {
    return InputDecoration(
      fillColor: Colors.transparent,
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide:
            BorderSide(color: Color.fromRGBO(218, 25, 33, 1), width: 3.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ),
      labelStyle: TextStyle(color: Colors.white54),
      // filled: true,
      labelText: _label,
    );
  }
}
