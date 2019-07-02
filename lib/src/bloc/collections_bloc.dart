import 'dart:async';

import 'package:AlboomPhotos/src/providers/db_provider.dart';

class CollectionsBloc {
  static final CollectionsBloc _singleton = new CollectionsBloc._internal();

  factory CollectionsBloc() {
    return _singleton;
  }

  CollectionsBloc._internal() {
    getCollections();
  }

  final _collectionsController = StreamController<List<Collection>>.broadcast();

  Stream<List<Collection>> get collectionsStream => _collectionsController.stream;

  dispose() {
    _collectionsController?.close();
  }

  getCollections() async {
    _collectionsController.sink.add(await DBProvider.db.getAllCollections());
  }

  addCollection(Collection collection) async {
    await DBProvider.db.newCollectionRaw(collection);
    getCollections();
  }

  deleteCollection(int id) async {
    await DBProvider.db.deleteCollection(id);
    getCollections();
  }

  deleteAll() async {
    await DBProvider.db.deleteAll();
    getCollections();
  }
}
