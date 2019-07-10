import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:AlboomPhotos/src/providers/collections_provider.dart';
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
          padding: EdgeInsets.symmetric(vertical: 5.0),
          itemCount: collections.length,
          itemBuilder: (context, i) => _itemBuilder(context, collections, i),
        );
      },
    );
  }

  Widget _itemBuilder(context, collections, i) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direction) => collectionsBloc.deleteCollection(collections[i].id),
            child: ListTile(
              //leading: Icon(Icons.map, color: Theme.of(context).primaryColor),
              leading: SizedBox(
                width: 60.0,
                height: 60.0,
                child: CachedNetworkImage(
                  imageUrl: CollectionProvider.getCroppedImage(collections[i].cover,
                      height: 120, width: 120),
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Center(
                      child: Image.asset("assets/loading.png"),
                    );
                  },
                ),
              ),
              title: Text(collections[i].name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${collections[i].photos.length} fotos'),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.copyright,
                        size: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        collections[i].ownerName,
                        style: TextStyle(color: Colors.black26),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () => Navigator.pushNamed(context, 'album', arguments: collections[i]),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
