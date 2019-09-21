import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_video_player/flutter_simple_video_player.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:share/share.dart';

import 'bloc/categories_bloc.dart';
import 'model/category_item.dart';

class Belleza extends StatefulWidget {
  @override
  _BellezaState createState() => _BellezaState();
}

class _BellezaState extends State<Belleza> {
  var product_list;
  CategoriesBloc _bloc = CategoriesBloc("belleza");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BELLEZA',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Lato",
              letterSpacing: 8),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: _bloc.categories,
        builder:
            (BuildContext context, AsyncSnapshot<List<CategoryItem>> snapshot) {
          if (!snapshot.hasData) {
            return Text("loading....");
          }
          int length = snapshot.data.length;
          return StaggeredGridView.countBuilder(
              itemCount: length,
              crossAxisCount: 4,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              itemBuilder: (_, int index) {
                final CategoryItem item = snapshot.data[index];
                return Single_prod(
                  item,
                  _bloc,
                );
              },
              staggeredTileBuilder: (index) => StaggeredTile.fit(2));

          /*GridView.builder(
              itemCount: length,

              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder:  (_, int index){
                final DocumentSnapshot doc = snapshot.data.documents[index];
                   return Single_prod(
                     prod_pricture: '${doc.data["image"]}' + '?alt=media',
                   );
              },
          );*/
        },
      ),
    );
  }
}

class Single_prod extends StatelessWidget {
  final CategoryItem documentData;
  final CategoriesBloc bloc;

  Single_prod(this.documentData, this.bloc) {}

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () {
            bloc.itemController.sink.add(documentData);

            showCupertinoDialog(
              context: context,
              builder: (context) {
                return GestureDetector(
                    child: Scaffold(
                  body: Stack(
                    children: <Widget>[
                      Story(
                        onFlashForward: Navigator.of(context).pop,
                        onFlashBack: Navigator.of(context).pop,
                        momentCount: 1,
                        momentDurationGetter: (idx) => Duration(seconds: 90),
                        momentBuilder: (context, idx) {
                          String a = documentData.image;
                          if (a.split('.').removeLast() == 'jpg') {
                            print('lo logre cabron');
                            return SimpleViewPlayer(
                                "https://firebasestorage.googleapis.com/v0/b/cocreacion-f17df.appspot.com/o/BELLEZA%2F58975402377__D92F80BF-E2FD-4914-BBBB-5AB17EC46418.MOV?alt=media&token=6cad85f0-17cd-4ac0-afff-49d3c9e22711",
                                isFullScreen: true);
                          } else {
                            print('pinche wey lo lograstes');
                            return Image.network(documentData.image
//                              documentData.toString(),
                                );
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment(-1, 1),
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              StreamBuilder<CategoryItem>(
                                  stream: bloc.item,
                                  builder: (context,
                                      AsyncSnapshot<CategoryItem> snapshot) {
                                    return InkWell(
                                      onTap: () {
                                        bloc.updateLike(
                                            snapshot.data.id,
                                            "belleza",
                                            !snapshot.data.likes
                                                .contains(bloc.user.uid));
                                      },
                                      child: Icon(
                                        snapshot.data.likes
                                                .contains(bloc.user.uid)
                                            ? CupertinoIcons.heart_solid
                                            : CupertinoIcons.heart,
                                        size: 50.0,
                                        color: Colors.black,
                                        //FontAwesomeIcons.heart,
                                        //size: 20.0,
                                      ),
                                    );
                                  }),
                              InkWell(
                                  onTap: () {
                                    Share.share(
                                        'chek my website https://www.excited.com.mx');
                                  },
                                  child: Icon(
                                    CupertinoIcons.share_up,
                                    //FontAwesomeIcons.shareAlt,
                                    size: 50.0,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        )),
                      )
                    ],
                  ),
                ));
              },
            );
            print(documentData.toString());
          },
          child: GridTile(
              child: Image.network(
            documentData.image,
            fit: BoxFit.cover,
          )),
        ),
      ),
    );
  }
}
