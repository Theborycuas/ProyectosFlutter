import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatefulWidget {
  SocialButton({Key key, this.title, this.image, this.link}) : super(key: key);

  final String title;
  final String image;
  final String link;
  final _social = 50.0;

  @override
  _SocialButtonState createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget._social),
        color: Colors.black,
      ),
      child: IconButton(
        onPressed: () {
          _launchURL(widget.link);
        },
        padding: EdgeInsets.all(0.0),
        tooltip: widget.title,
        icon: Image.asset(
          widget.image,
          fit: BoxFit.cover,
          height: widget._social,
          width: widget._social,
        ),
      ),
    );
  }
}
