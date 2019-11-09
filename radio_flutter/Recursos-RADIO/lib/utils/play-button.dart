import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';

class PlayButton extends StatefulWidget {
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  static const streamUrl = "http://94.23.40.42:8068/;";
  // static const streamUrl = "http://94.23.87.98:9048/;";
  bool isPlaying = true;

  Icon _iconStateChange = new Icon(
    Icons.play_arrow,
    color: Colors.white,
    size: 80.0,
  );

  @override
  void initState() {
    super.initState();

    audioStart();
    playStream();
  }

  @override
  void dispose() {
    FlutterRadio.stop();
    super.dispose();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  Future playStream() async {
    FlutterRadio.playOrPause(url: streamUrl);
    if (isPlaying) {
      _iconStateChange = new Icon(
        Icons.pause,
        color: Colors.white,
        size: 80.0,
      );
    } else {
      _iconStateChange = new Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 80.0,
      );
    }
    isPlaying = !isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1),
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(100.0),
          onTap: () {
            setState(() {
              playStream();
            });
          },
          child: _iconStateChange,
        ),
      ),
    );
  }
}
