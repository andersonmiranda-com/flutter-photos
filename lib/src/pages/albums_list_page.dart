import 'package:flutter/material.dart';

import 'package:AlboomPhotos/src/bloc/collections_bloc.dart';
import 'package:AlboomPhotos/src/models/collection_model.dart';

class AlbumsListPage extends StatelessWidget {
  final collectionsBloc = new CollectionsBloc();

  @override
  Widget build(BuildContext context) {
    collectionsBloc.getCollections();

    return StreamBuilder<List<Collection>>(
      stream: collectionsBloc.collectionsStreamAlbums,
      builder: (BuildContext context, AsyncSnapshot<List<Collection>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final collections = snapshot.data;

        if (collections.length == 0) {
          return Center(
            child: Text('Ainda sem álbuns por aqui'),
          );
        }

        return ListView.builder(
          itemCount: collections.length,
          itemBuilder: (context, i) => Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (direction) => collectionsBloc.deleteCollection(collections[i].id),
                child: ListTile(
                  leading: Icon(Icons.map, color: Theme.of(context).primaryColor),
                  title: Text(collections[i].name),
                  subtitle: Text('ID: ${collections[i].id}'),
                  trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                  onTap: () => Navigator.pushNamed(context, 'gallery', arguments: collections[i]),
                ),
              ),
        );
      },
    );
  }
}
