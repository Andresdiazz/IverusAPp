import 'dart:async';
import 'dart:math';

import 'package:cocreacion/Categorias/bloc/categories_bloc.dart';
import 'package:cocreacion/Categorias/model/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class AnimatedShareButton extends StatefulWidget {
  final CategoryItem documentData;
  final CategoriesBloc bloc;

  AnimatedShareButton({Key key, this.bloc, this.documentData})
      : super(key: key);

  @override
  _AnimatedShareButtonState createState() => _AnimatedShareButtonState();
}

class _AnimatedShareButtonState extends State<AnimatedShareButton>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
        //margin: EdgeInsets.only(left: 300.0,top:700.0),
        child: Stack(
      alignment: FractionalOffset.center,
      overflow: Overflow.visible,
      children: <Widget>[
        getLikeButton(),
      ],
    ));
  }

  Widget getLikeButton() {
    var extraSize = 0.0;

    return GestureDetector(
        onTap: () {
          //_shareImageAndText();
          _shareImage();
        },
        child: Container(
          height: 90.0 + extraSize,
          width: 90.0 + extraSize,
          padding: EdgeInsets.all(10.0),
          /*decoration: BoxDecoration(
              border: Border.all(color: Color(0xff23A8C5), width: 1.0),
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 40.0)]),*/
          child: getHeartIcon(),
        ));
  }

//

  Widget getHeartIcon() {
    return Icon(
      FontAwesomeIcons.solidPaperPlane,
      color: Colors.white,
    );
  }

  void _shareImageAndText() async {
    try {
      final ByteData bytes = await rootBundle.load(
          'https://firebasestorage.googleapis.com/v0/b/cocreacion-f17df.appspot.com/o/Assets%2Fimg%2Fexcited.png?alt=media&token=6b1d9929-44e0-4d46-8dce-5c42e438dd03');
      await WcFlutterShare.share(
          sharePopupTitle: 'share',
          subject: 'This is subject',
          text: 'This is text',
          fileName: 'share.png',
          mimeType:
              'https://firebasestorage.googleapis.com/v0/b/cocreacion-f17df.appspot.com/o/Assets%2Fimg%2Fexcited.png?alt=media&token=6b1d9929-44e0-4d46-8dce-5c42e438dd03',
          bytesOfFile: bytes.buffer.asUint8List());
    } catch (e) {
      print('error: $e');
    }
  }

  void _shareImage() async {
    print("share click");
    try {
      widget.bloc.updateShare(widget.documentData.id, widget.bloc.category);

//      final ByteData bytes = await rootBundle.load(
//          'https://firebasestorage.googleapis.com/v0/b/cocreacion-f17df.appspot.com/o/Assets%2Fimg%2Fexcited.png?alt=media&token=6b1d9929-44e0-4d46-8dce-5c42e438dd03');
      await WcFlutterShare.share(
          sharePopupTitle: 'share',
//          fileName: 'excited.png',
          mimeType: 'text/plain',
          text:
              'https://firebasestorage.googleapis.com/v0/b/cocreacion-f17df.appspot.com/o/Assets%2Fimg%2Fexcited.png?alt=media&token=6b1d9929-44e0-4d46-8dce-5c42e438dd03'
//          bytesOfFile: bytes.buffer.asUint8List()
          );
    } catch (e) {
      print('error: $e');
    }
  }
}
