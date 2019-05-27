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
            child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: BackButton(),
              ),
            ),
            CarouselSlider(
              height: 400.0,
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
          ],
        )));
  }
}
