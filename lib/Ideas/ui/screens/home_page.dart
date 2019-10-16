import 'package:cocreacion/Ideas/ui/widgets/sliding_cards.dart';
import 'package:cocreacion/Ideas/ui/widgets/tabs.dart';
import 'package:cocreacion/Users/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'exhibition_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      bloc: HomeBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8),
                  Header(),
                  SizedBox(height: 40),
                  Tabs(),
                  SizedBox(height: 20),
                  SlidingCardsView(),
                ],
              ),
            ),
            ExhibitionBottomSheet(),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Image(
          image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/cocreacion-f17df.appspot.com/o/Assets%2Fimg%2Fiverus.png?alt=media&token=8bda555c-2603-4b97-bf71-564e630dd3c0"),
          width: 150,
        )
        /*Text(
        'Iverus',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),*/
        );
  }
}
