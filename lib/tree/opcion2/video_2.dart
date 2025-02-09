import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocreacion/tree/delayed_animation.dart';
import 'package:cocreacion/tree/opcion2/video_2_1.dart';
import 'package:cocreacion/tree/opcion2/video_2_2.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class Video_2 extends StatefulWidget {
  String idVideo;
  String tipo;
  Video_2(this.idVideo, this.tipo);
  @override
  _Video_2State createState() => _Video_2State(this.idVideo, this.tipo);
}

class _Video_2State extends State<Video_2> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  VideoPlayerController _controllervideo;

  _Video_2State(String idVideo, String tipo);

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection(widget.tipo)
        .document(widget.idVideo)
        .collection('0')
        .document('2')
        .snapshots()
        .forEach((doc) => {
              _controllervideo =
                  VideoPlayerController.network(doc.data['video'])
                    ..initialize().then((_) {
                      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                      setState(() {
                        _controllervideo.play();
                      });
                    })
            });
  }

  var _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: 420.0,
              child: _controllervideo?.value?.initialized ?? false
                  ? AspectRatio(
                      aspectRatio: _controllervideo.value.aspectRatio,
                      child: VideoPlayer(_controllervideo),
                    )
                  : Container(),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 200.0,
                      height: MediaQuery.of(context).size.height,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Video_2_1(widget.idVideo, widget.tipo)));
                        },
                      ),
                    ),
                    Visibility(
                        visible: true,
                        child: Container(
                          width: 175.0,
                          height: MediaQuery.of(context).size.height,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Video_2_2(
                                          widget.idVideo, widget.tipo)));
                            },
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controllervideo.dispose();
  }
}
