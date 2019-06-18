import "package:flutter/material.dart";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_advanced_networkimage/zoomable.dart';

class PhotoPage extends StatefulWidget {
  final List proofRows;
  final int index;
  final String urlPrefix;
  final Function setSelect;

  PhotoPage(this.proofRows, this.index, this.urlPrefix, this.setSelect);

  PhotoPageState createState() => PhotoPageState();
}

class PhotoPageState extends State<PhotoPage> {
  int _currentSlide;

  initState() {
    super.initState();
    _currentSlide = widget.index;
  }

  void _setSelect(i) {
    print(i);
    String finalState;

    if (widget.proofRows[_currentSlide]["taken"] == "1") {
      finalState = "0";
    } else {
      finalState = "1";
    }

    widget.setSelect(i, finalState);
    setState(() {
      widget.proofRows[_currentSlide]["taken"] = finalState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            CarouselSlider(
                height: MediaQuery.of(context).size.height - 10,
                aspectRatio: 1.0,
                initialPage: widget.index,
                enableInfiniteScroll: false,
                items: widget.proofRows.map((photo) {
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
                                      Color(0xff303030),
                                    ),
                                  )),
                              //errorWidget: (context, url, error) => new Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                onPageChanged: (i) => {
                      setState(() {
                        if (i + widget.index >= widget.proofRows.length) {
                          _currentSlide = widget.index - (widget.proofRows.length - i);
                        } else {
                          _currentSlide = widget.index + i;
                        }
                      })
                    }),
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
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          _setSelect(_currentSlide);
                        },
                        child: widget.proofRows[_currentSlide]["taken"] == "1"
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.amber,
                                size: 30.0,
                              )
                            : Icon(
                                Icons.check,
                                color: Color(0x60ffffff),
                                size: 30.0,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
