import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';
import 'dart:math';

class RadioInterface extends StatefulWidget {
  @override
  _RadioInterfaceState createState() => new _RadioInterfaceState();
}

class _RadioInterfaceState extends State<RadioInterface> {
  double _thumbPercent = 0.4;

    static const streamUrl =
      "https://transom.org/2004/web-audio-mp3-streaming/";

  bool isPlaying;

  @override
  void initState() {
    super.initState();
    audioStart();
    playingStatus();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  } 

  Widget _buildRadialSeekBar() {
    return RadialSeekBar(
      trackColor: Colors.red.withOpacity(.5),
      trackWidth: 2.0,
      progressColor: Color(0xFFFE1483),
      progressWidth: 5.0,
      thumbPercent: _thumbPercent,
      thumb: CircleThumb(
        color: Color(0xFFFE1483),
        diameter: 20.0,
      ),
      progress: _thumbPercent,
      onDragUpdate: (double percent) {
        setState(() {
          _thumbPercent = percent;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
            onPressed: () {},
          ),
          title: Text("Music World",
              style: TextStyle(color: Color(0xFFFE1483), fontFamily: "Nexa")),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu, color: Colors.blueAccent),
              onPressed: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Center(
                child: Container(
                  width: 250.0,
                  height: 250.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(.5),
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _buildRadialSeekBar(),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipOval(
                              clipper: MClipper(),
                              child: Image.asset(
                                "assets/images/lavoz.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Radio La Voz de su Amigo",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20.0,
                        fontFamily: "Nexa"),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Esmeraldas",
                    style: TextStyle(
                        color: Color(0xFFFE1483),
                        fontSize: 18.0,
                        fontFamily: "NexaLight"),
                  )
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                width: 350.0,
                height: 150.0,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 65.0,
                        width: 290.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent, width: 3.0),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.fast_rewind,
                                  size: 55.0, color: Color(0xFFFE1483)),
                              Expanded(
                                child: Container(),
                              ),
                              Icon(Icons.fast_forward,
                                  size: 55.0, color: Color(0xFFFE1483))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 92.0,
                        height: 92.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent, shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            size: 45.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                             FlutterRadio.playOrPause(url: streamUrl);
                              playingStatus();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 190.0,
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: -25,
                      child: Container(
                        width: 50.0,
                        height: 190.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0))),
                      ),
                    ),
                    Positioned(
                      right: -25,
                      child: Container(
                        width: 50.0,
                        height: 190.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0))),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          song("assets/images/lavoz.png", "Juan Camaney",
                              "Buena Radio"),
                          song("assets/images/lavoz.png", "Luis",
                              "Saludos"),
                          song("assets/images/lavoz.png", "Jose",
                              "Animo La Voz Saludos"),
                              
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }   
}

Widget song(String image, String title, String subtitle) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          image,
          width: 40.0,
          height: 40.0,
        ),
        SizedBox(
          width: 8.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(color: Colors.blueAccent)),
            Text(subtitle, style: TextStyle(color: Colors.blueAccent))
          ],
        )
      ],
    ),
  );
}

class MClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }


 
}
