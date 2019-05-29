import "package:flutter/material.dart";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_advanced_networkimage/zoomable.dart';

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
              aspectRatio: 1.0,
              initialPage: index,
              enableInfiniteScroll: false,
              items: proofRows.map((photo) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ZoomableWidget(
                        singleFingerPan: false,
                        autoCenter: true,
                        enableFling: false,
                        minScale: 1.0,
                        maxScale: 3.0,
                        // default factor is 1.0, use 0.0 to disable boundary
                        panLimit: 1.0,
                        child: Container(
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/723/" +
                                    photo["file"],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation(
                                      Color(0xff303030)),
                                )),
                            //errorWidget: (context, url, error) => new Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
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
