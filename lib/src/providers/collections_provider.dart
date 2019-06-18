import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:AlboomPhotos/src/models/collection_model.dart';

class CollectionProvider {
  String _url = 'https://proof-api.alboompro.com/api/app/proofs/';

  bool _loading = false;

  static Future<Collection> getCollection(collectionId) async {
    final resp = await http.get('https://proof-api.alboompro.com/api/app/proofs/' + collectionId);
    final decodedData = json.decode(resp.body);
    final collection = new Collection.fromJson(decodedData["collection"]);
    return collection;
  }

  static String getReducedImage(String imageUrl, {int width: 150, int height: 150}) {
    String alfredUrl = "https://alfred.alboompro.com/resize/width/$width/heigth/$height/url/";
    String url = imageUrl.replaceAll('https://', '');
    url = url.replaceAll('http://', '');
    //print(alfredUrl + Uri.encodeFull(url));
    return alfredUrl + Uri.encodeFull(url);
  }
}
