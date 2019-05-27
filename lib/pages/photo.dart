import "package:flutter/material.dart";
import 'package:carousel_slider/carousel_slider.dart';

class PhotoPage extends StatelessWidget {
  final List proofRows;
  final int index;
  final String urlPrefix;

  PhotoPage(this.proofRows, this.index, this.urlPrefix);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff202020),
        body: Container(
            child: Stack(
          children: <Widget>[
            CarouselSlider(
              height: MediaQuery.of(context).size.height - 10,
              aspectRatio: 16 / 9,
              initialPage: index,
              items: proofRows.map((photo) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.network(
                          urlPrefix + photo["file"],
                          fit: BoxFit.contain,
                        ));
                  },
                );
              }).toList(),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SafeArea(
                      child: BackButton(),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SafeArea(
                      child: BackButton(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )));
  }
}
