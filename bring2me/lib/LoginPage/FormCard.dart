import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FormCard extends StatelessWidget {
  
  TextEditingController _emailController = TextEditingController();
  TextEditingController _paswordcontroller = TextEditingController();
  bool passwordVisible = true;

  @override
  void initState() {
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
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
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Login",
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
              obscureText: true,
            
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
                      
                        passwordVisible
                        ? passwordVisible = false
                        : passwordVisible = true;
                    
                    },
                  )
                  ),
                  
            ),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(28)),
                )
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
