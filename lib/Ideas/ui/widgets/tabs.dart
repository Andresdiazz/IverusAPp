import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(width: 24),
        MyTab(text: 'Shows', isSelected: true),
        //MyTab(text: 'Shopping', isSelected: false,)
      ],
    );
  }
}

class MyTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const MyTab({Key key, @required this.isSelected, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
                fontSize: isSelected ? 16 : 14,
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                fontFamily: "Aileron"),
          ),
          Container(
            height: 6,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isSelected ? Colors.cyan : Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
