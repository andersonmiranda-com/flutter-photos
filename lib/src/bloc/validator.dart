import 'dart:async';

import 'package:AlboomPhotos/src/models/collection_model.dart';

class Validators {
  final validateAlbums =
      StreamTransformer<List<Collection>, List<Collection>>.fromHandlers(handleData: (scans, sink) {
    final collectionsScans = scans.where((s) => s.type == 'album').toList();
    sink.add(collectionsScans);
  });

  final validatePhotos =
      StreamTransformer<List<Collection>, List<Collection>>.fromHandlers(handleData: (scans, sink) {
    final collectionsScans = scans.where((s) => s.type == 'photos').toList();
    sink.add(collectionsScans);
  });
}
