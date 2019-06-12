import 'package:AlboomPhotos/src/pages/album_page.dart';
import 'package:AlboomPhotos/src/pages/gallery_page.dart';
import 'package:AlboomPhotos/src/pages/start_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => StartPage(),
    //'list': (BuildContext context) => ListPage(),
    'gallery': (BuildContext context) => GalleryPage(),
    'album': (BuildContext context) => AlbumPage(),
  };
}
