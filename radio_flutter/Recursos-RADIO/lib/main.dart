import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtrema/utils/sideBar.dart';
import 'package:xtrema/utils/play-button.dart';
import 'package:xtrema/utils/social-button.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radio Xtrema',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        secondaryHeaderColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: AfterSplash(),
      image: Image.asset(
        'assets/images/logo.png',
        alignment: Alignment.bottomCenter,
      ),
      backgroundColor: Colors.black,
      photoSize: 120.0,
      loaderColor: Colors.white,
      loadingText: Text(
        'Salvajemente Diferente',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: null,
        elevation: 0.0,
        leading: Builder(builder: (BuildContext context) {
          return new GestureDetector(
            child: IconButton(
              icon: Icon(Icons.menu),
              tooltip: 'Menu',
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              splashColor: Colors.white,
            ),
          );
        }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 250.0,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            PlayButton(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Salvajemente Diferente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SocialButton(
                    title: 'Facebook',
                    image: 'assets/images/facebook-white.png',
                    link: 'https://flutter.dev/'),
                SocialButton(
                    title: 'Whatsapp',
                    image: 'assets/images/whatsapp-white.png',
                    // link: 'https://wa.me/593999008196'),
                    link:
                        'https://wa.me/593988009054?text=Hello!%20my%20friend'),
                SocialButton(
                    title: 'Twitter',
                    image: 'assets/images/twitter-white.png',
                    link: 'https://flutter.dev/'),
                SocialButton(
                    title: 'Instagram',
                    image: 'assets/images/instagram-white.png',
                    link: 'https://flutter.dev/'),
              ],
            ),
          ],
        ),
      ),
      drawer: SideBar(),
    );
  }
}