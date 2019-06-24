import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class SliderImage extends StatefulWidget {
  SliderImage({Key key}) : super(key: key);

  _SliderImageState createState() => _SliderImageState();
}

class _SliderImageState extends State<SliderImage> {
  @override
  Widget build(BuildContext context) {
    return  Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 180.0,
          child: Carousel(
                boxFit: BoxFit.cover,
                images: [
                  AssetImage('assets/images/slider.jpg'),
                  AssetImage('assets/images/slider.jpg'),
                  AssetImage('assets/images/slider.jpg'),
                  AssetImage('assets/images/slider.jpg'),
                ],
                animationCurve: Curves.fastOutSlowIn,
                animationDuration: Duration(milliseconds: 2000),
                
              )    
        );
  }
}