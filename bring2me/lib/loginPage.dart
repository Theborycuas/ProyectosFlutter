import 'package:bring2me/LoginPage/CustomIcons.dart';
import 'package:bring2me/LoginPage/SocialIcons.dart';
import 'package:bring2me/login/register_page.dart';
import 'package:bring2me/login/signin_google_perfil.dart';
import 'package:bring2me/ui/uiAllProduct/productHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
class MyAppLoginPage extends StatefulWidget {
  const MyAppLoginPage({Key key,}) : super(key: key);  

  @override
  _MyAppLoginPageState createState() => new _MyAppLoginPageState();
}

class _MyAppLoginPageState extends State<MyAppLoginPage> {
    TextEditingController _emailController = TextEditingController();
  TextEditingController _paswordcontroller = TextEditingController();

  bool passwordVisible = true;

  @override
  void initState() {
    
    _emailController = TextEditingController(text: "");
    _paswordcontroller = TextEditingController(text: "");
    passwordVisible = true;
  }
  bool _isSelected = false;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Image.asset("assets/images/logo.png", width: 180.0,),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/images/image_02.png")
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/logo.png",
                        width: ScreenUtil.getInstance().setWidth(110),
                        height: ScreenUtil.getInstance().setHeight(110),
                      ),
                      Text("BIENVENIDO",
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: ScreenUtil.getInstance().setSp(35),
                              letterSpacing: .6,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(180),
                  ),
                  Container(
                          width: double.infinity,
                          height: ScreenUtil.getInstance().setHeight(475.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0, 15.0),
                                    blurRadius: 15.0),
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0, -10.0),
                                    blurRadius: 10.0),
                              ]),
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0,),
                            child: ListView(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Iniciar Sesión",
                                        style: TextStyle(
                                            fontSize: ScreenUtil.getInstance().setSp(45),
                                            fontFamily: "Poppins-Bold",
                                            letterSpacing: .6)),
                                    SizedBox(
                                      height: ScreenUtil.getInstance().setHeight(30),
                                    ),
                                    
                                    TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Usuario',
                                        icon: Icon(Icons.person),
                                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil.getInstance().setHeight(30),
                                    ),
                                  
                                    TextField(
                                      controller: _paswordcontroller,
                                      
                                    
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña',
                                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                                          icon: Icon(Icons.vpn_key),
                                          suffixIcon: IconButton(
                                                      icon: Icon(
                                                        passwordVisible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                        color: Theme.of(context).primaryColorDark,
                                                      ),
                                                      onPressed: (){
                                                        setState(() {
                                                          passwordVisible
                                                          ? passwordVisible = false
                                                          : passwordVisible = true;
                                                        });
                                                      },
                                                    ),
                                                    
                                          ),
                                          obscureText: passwordVisible,
                                          
                                    ),
                                    SizedBox(
                                      height: ScreenUtil.getInstance().setHeight(35),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "Olvidaste tu contraseña?",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontFamily: "Poppins-Medium",
                                              fontSize: ScreenUtil.getInstance().setSp(28)),
                                        )
                                      ],
                                    ),
                                    
                                  ],
                                ),
                              ],
                            )
                          ),
                        ),
                
                      SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 12.0,
                              ),
                              GestureDetector(
                                onTap: _radio,
                                child: radioButton(_isSelected),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text("Recuérdame  ",
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: "Poppins-Medium"))
                            ],
                          ),
                          InkWell(
                            child: Container(
                              width: ScreenUtil.getInstance().setWidth(330),
                              height: ScreenUtil.getInstance().setHeight(100),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF17ead9),
                                    Color(0xFF6078ea)
                                  ]),
                                  borderRadius: BorderRadius.circular(6.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF6078ea).withOpacity(.3),
                                        offset: Offset(0.0, 8.0),
                                        blurRadius: 8.0)
                                  ]),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                      _signInEmail(context);

                                  },
                                  child: Center(
                                    child: Text("INGRESAR",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Poppins-Bold",
                                            fontSize: 18,
                                            letterSpacing: 1.0)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(40),
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("Ingresa Con:",
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: "Poppins-Medium")),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /* SocialIcon(
                        colors: [
                          Color(0xFF102397),
                          Color(0xFF187adf),
                          Color(0xFF00eaf8),
                        ],
                        iconData: CustomIcons.facebook,
                        onPressed: () {},
                      ), */
                      SocialIcon(
                        colors: [
                          Color(0xFFff4f38),
                          Color(0xFFff355d),
                        ],
                        iconData: CustomIcons.googlePlus,
                        onPressed: () {
                           authService.googleSignIn(context);
                           darkMode: true;
                        },
                      ),
                      /* SocialIcon(
                        colors: [
                          Color(0xFF17ead9),
                          Color(0xFF6078ea),
                        ],
                        iconData: CustomIcons.twitter,
                        onPressed: () {},
                      ),
                      SocialIcon(
                        colors: [
                          Color(0xFF00c6fb),
                          Color(0xFF005bea),
                        ],
                        iconData: CustomIcons.linkedin,
                        onPressed: () {},
                      ) */
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Usuario Nuevo? ",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => RegisterPage()
                      ));
                        },
                        child: Text("REGISTRATE",
                            style: TextStyle(
                                color: Color(0xFF5d74e3),
                                fontFamily: "Poppins-Bold")),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Null> _signInEmail(BuildContext context) async{
    FirebaseUser user;

    try {
      user = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _paswordcontroller.text,
      );
    } catch (e) {
      print(e.toString());
    }
    finally {
      if (user != null) {
        // sign in successful!
            Firestore.instance.collection('usuarios').document(user.uid).get().then((DocumentSnapshot usuarioDoc){
               Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProductHomePage(usu: user)));
              showToast("Bienvenido a BRING2ME ${usuarioDoc.data["nombres"]}", context, 
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);  
       });
      } else {
        // sign in unsuccessful
        showToast("Clave o contraseña incorrecta", context, 
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);  
        print('sign in Not');
      }
    }
  
/* 
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _paswordcontroller.text,
       ).then((FirebaseUser user){
            Firestore.instance.collection('usuarios').document(user.uid).get().then((DocumentSnapshot usuarioDoc){
               Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProductHomePage(usu: user, docUsu: usuarioDoc,)));
              showToast("Bienvenido a BRING2ME ${usuarioDoc.data["nombres"]}", context, 
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);  
       });
         }).catchError((e){
               print(e);
               showToast(e, context, 
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM); 
               
           }); 
            */
              
     
  }
    void showToast(String msg, BuildContext context, {int duration, int gravity}) 
  {
    Toast.show(msg, context, duration: duration, gravity: gravity);
   }
}