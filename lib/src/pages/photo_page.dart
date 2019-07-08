import 'package:AlboomPhotos/src/models/collection_model.dart';
import 'package:AlboomPhotos/src/providers/collections_provider.dart';
import "package:flutter/material.dart";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_advanced_networkimage/zoomable.dart';

class PhotoPage extends StatefulWidget {
  final Collection _collection;
  final int index;
  final Function setSelect;

  PhotoPage(this._collection, this.index, this.setSelect);

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
  }

  @override
  Widget build(BuildContext context) {
    final _preCache0 = (_currentSlide > 1) ? _currentSlide - 1 : _currentSlide;
    final _preCache1 =
        (_currentSlide < widget._collection.photos.length - 1) ? _currentSlide + 1 : _currentSlide;
    final _preCache2 =
        (_currentSlide < widget._collection.photos.length - 2) ? _currentSlide + 2 : _currentSlide;

    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      backgroundColor: Color(0xff303030),
      body: Container(
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.0,
              child: CachedNetworkImage(
                imageUrl: CollectionProvider.getReducedImage(
                    widget._collection.photos[_preCache2].url,
                    width: 800,
                    height: 800),
              ),
            ),
            Opacity(
              opacity: 0.0,
              child: CachedNetworkImage(
                imageUrl: CollectionProvider.getReducedImage(
                    widget._collection.photos[_preCache1].url,
                    width: 800,
                    height: 800),
              ),
            ),
            Opacity(
              opacity: 0.0,
              child: CachedNetworkImage(
                imageUrl: CollectionProvider.getReducedImage(
                    widget._collection.photos[_preCache0].url,
                    width: 800,
                    height: 800),
              ),
            ),
            CarouselSlider(
//                height: MediaQuery.of(context).size.height - 10,
//                aspectRatio: 1.0,
                initialPage: widget.index,
//                autoPlay: true,
                viewportFraction: 1.1,
                aspectRatio: MediaQuery.of(context).size.aspectRatio,
                enableInfiniteScroll: false,
                items: widget._collection.photos.map((photo) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
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
                              imageUrl: CollectionProvider.getReducedImage(photo.url,
                                  width: 800, height: 800),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                                    ),
                                  ),
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
                        if (i + widget.index >= widget._collection.photos.length) {
                          _currentSlide = widget.index - (widget._collection.photos.length - i);
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
                      child: BackButton(color: Colors.white),
                    ),
                  ),
                ),
                /*                 Container(
                  padding: EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          _setSelect(_currentSlide);
                        },
                        child: widget._collection.photos[_currentSlide]["taken"] == "1"
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

*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
