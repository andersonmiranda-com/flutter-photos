import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:AlboomPhotos/src/models/collection_model.dart';
export 'package:AlboomPhotos/src/models/collection_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'CollectionsDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Collections ('
          ' id INTEGER,'
          ' type TEXT,'
          ' name TEXT,'
          ' message TEXT,'
          ' diagramation TEXT,'
          ' shareable TEXT,'
          ' description TEXT,'
          ' photographedAt TEXT,'
          ' status TEXT,'
          ' cover TEXT,'
          ' ownerName TEXT,'
          ' ownerLogoText TEXT,'
          ' ownerLogoType TEXT,'
          ' ownerLogo TEXT,'
          ' priv TEXT,'
          ' photos TEXT'
          ')');
    });
  }

  newCollectionRaw(Collection newCollection) async {
    final db = await database;
    final res = await db.rawInsert(
        "INSERT Into Collections (id, type, name, message, diagramation, shareable, description, "
        " photographedAt, status, cover, ownerName, ownerLogoText, ownerLogoType, ownerLogo, priv, photos) "
        " VALUES ("
        "  ${newCollection.id},"
        " '${newCollection.type}', "
        " '${newCollection.name}', "
        " '${newCollection.message}', "
        " '${newCollection.diagramation}', "
        " '${newCollection.shareable}', "
        " '${newCollection.description}', "
        " '${newCollection.photographedAt.toString()}', "
        " '${newCollection.status}', "
        " '${newCollection.cover}', "
        " '${newCollection.ownerName}', "
        " '${newCollection.ownerLogoText}', "
        " '${newCollection.ownerLogoType}', "
        " '${newCollection.ownerLogo}', "
        " '${newCollection.priv}', "
        " '${newCollection.photos}' )");
    return res;
  }

  newCollection(Collection newCollection) async {
    final db = await database;
    final res = await db.insert('Collections', newCollection.toJsonDB());
    return res;
  }

  Future<Collection> getCollId(int id) async {
    final db = await database;
    final res = await db.query('Collections', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Collection.fromJsonDB(res.first) : null;
  }

  Future<List<Collection>> getAllCollections() async {
    final db = await database;
    final res = await db.query('Collections');
    List<Collection> list = res.isNotEmpty ? res.map((c) => Collection.fromJsonDB(c)).toList() : [];
    return list;
  }

  Future<List<Collection>> getCollectionsByType(String type) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Collections WHERE type='$type'");
    List<Collection> list = res.isNotEmpty ? res.map((c) => Collection.fromJsonDB(c)).toList() : [];
    return list;
  }

  Future<int> updateCollection(Collection newCollection) async {
    final db = await database;
    final res = await db.update('Collections', newCollection.toJsonDB(),
        where: 'id = ?', whereArgs: [newCollection.id]);
    return res;
  }

  Future<int> upsertCollection(Collection newCollection) async {
    final db = await database;

    final res = await db.query('Collections', where: 'id = ?', whereArgs: [newCollection.id]);

    if (res.isNotEmpty) {
      final res2 = await db.update('Collections', newCollection.toJsonDB(),
          where: 'id = ?', whereArgs: [newCollection.id]);
      return res2;
    } else {
      final res2 = await db.insert('Collections', newCollection.toJsonDB());
      return res2;
    }
  }

  // Eliminar registros
  Future<int> deleteCollection(int id) async {
    final db = await database;
    final res = await db.delete('Collections', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Collections');
    return res;
  }
}
