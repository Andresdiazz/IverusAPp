import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocreacion/Ideas/ui/screens/home_page.dart';
import 'package:cocreacion/tree/delayed_animation.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';


class Positiva extends StatefulWidget {
  String idVideo;
  String tipo;
  Positiva(this.idVideo,this.tipo);
  @override
  _PositivaState createState() => _PositivaState(this.idVideo,this.tipo);
}

class _PositivaState extends State<Positiva> with SingleTickerProviderStateMixin {

  VideoPlayerController _controllervideo;

  _PositivaState(String idVideo ,String tipo);

  @override
  void initState() {

    super.initState();
    Firestore.instance
        .collection (widget.tipo)
        .document(widget.idVideo).collection('0').document('1_positivo')
        .snapshots().forEach((doc)=> {
      _controllervideo = VideoPlayerController.network( doc.data['video'])
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

            child:Stack(
              children: <Widget>[
                Container(
                  height: 812.0,
                  width: 420.0,
                  child:  _controllervideo?.value?.initialized ?? false
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
                          height: 810.0,

                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));


                            },
                          ),
                        ),
                        Visibility(
                            visible: true,
                            child: Container(

                              width: 175.0,
                              height: 810.0,

                              child: InkWell(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));

                                },
                              ),
                            )
                        )

                      ],
                    ),
                  ],
                ),
              ],
            )

        ),
      ),

    );

  }
  @override
  void dispose() {
    super.dispose();
    _controllervideo.dispose();
  }
}
