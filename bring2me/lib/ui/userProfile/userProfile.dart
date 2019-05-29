import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key key, @required this.user, this.usuDoc}):super(key:key);
  final FirebaseUser user;
  final DocumentSnapshot usuDoc;

  @override
  _UserProfileState createState() => new _UserProfileState();
 }
 //imagen
  File image = null;
  String filename = null; //image

class _UserProfileState extends State<UserProfile> {
  final color = Color(0xFF11E8161);
  @override
  Widget build(BuildContext context) {
     final height = MediaQuery.of(context).size.height / 1.8;
    final width = MediaQuery.of(context).size.width;
   return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color,
        title: Text('Perfil'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          buildTop(height, width),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                 /*  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      buildOption(Icons.pie_chart, 'Leaders', false),
                      buildOption(Icons.show_chart, 'Level Up', false),
                      buildOption(Icons.card_giftcard, 'Gifts', false),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      buildOption(Icons.code, 'QR Code', false),
                      buildOption(Icons.pie_chart, 'Daily bonus', false),
                      buildOption(Icons.remove_red_eye, 'Visitors', false),
                    ],
                  ), */
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTop(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: height * 0.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /* Container(
                  width: width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Familiar',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '12',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                ), */
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: widget.usuDoc.data["foto"] != "" ? NetworkImage(widget.usuDoc.data["foto"]) 
                                      : NetworkImage("https://insidelatinamerica.net/wp-content/uploads/2018/01/noImg_2.jpg"),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        'Telefono: ${widget.usuDoc["telefono"]}',
                        style: TextStyle(color: Colors.white70),
                      )
                    ],
                  ),
                ),
                /* Container(
                  width: width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Fallowing',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '18',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                ), */
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Text(
              widget.usuDoc["nombres"],
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                
                buildOption(Icons.camera_alt, "Tomar Foto", true),
                buildOption(Icons.phone, "Telefono", true),
                buildOption(Icons.videocam, "Videos", true),
                buildOption(Icons.favorite, "Likes", true),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildOption(IconData icon, String text, bool top) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
              child: Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Icon(
                icon,
                size: 37.0,
                color: top ? Colors.white : Colors.grey,
              ),
            ),

            onTap: (){
              switch (text) {
                case "Tomar Foto": {
                  print("hi");
                  _getImage();
                  }                  
                  break;
                case "Telefono": {
                  print("12");
                  }                  
                  break;                  
                default:
              }
            },
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 15.0,
            color: top ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

   //Seleccionar imagen o tmar foto. 
  Future _getImage() async{
    var selectedImage =await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
    image = selectedImage;
    filename = basename(image.path);
    });
    uploadImage();

}//imagen
Future<String> uploadImage ()async{
  StorageReference ref = FirebaseStorage.instance.ref().child(filename);
  StorageUploadTask uploadTask = ref.putFile(image);

  var downUrl =await (await uploadTask.onComplete).ref.getDownloadURL();
  
  var url = downUrl.toString(); 
  CloudFunctions.instance.call(
    functionName: "actualizarUsuarioBring",
    parameters: {
        'doc_id': widget.user.uid,
        'uid' : widget.user.uid,
        'nombres' : widget.user.displayName,
        'telefono': widget.user.phoneNumber,
        'direccion':'',
        'ubicacion': '',
        'correo' :widget.user.email,
        'clave' :widget.user.uid,  
        'foto' :url,
         'ultimoacceso' :DateTime.now().toString(),                         
                    }
                  );
/*     setState(() { 
        

    }); */

  return url;

}//imagen
  


}