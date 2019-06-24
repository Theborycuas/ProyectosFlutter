import 'package:carouselpro/sliderImage.dart';
import 'package:flutter/material.dart';

class Sliderwidget extends StatefulWidget {
  

  _SliderwidgetState createState() => _SliderwidgetState();
}

class _SliderwidgetState extends State<Sliderwidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slider"),
      ),
      body: Container(          
          
          child: ListView(
            children: <Widget>[ 
              
              SliderImage(),
              SliderImage(),
              SliderImage(),
            ],
          ),
        ),
      /* Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                         Expanded(
                            child: Image.asset("assets/images/slider.jpg", height: 235.0,),
                          )
                      ],
                    )
                      ],
                    )
                   
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.asset("assets/images/slider.jpg", height: 235.0,),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.asset("assets/images/slider.jpg", height: 235.0,),
                    )
                  ],
                ),
              ],
            )
          ],
        )
      ) */
    );
 
  }
}
  