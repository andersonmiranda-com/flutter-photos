import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:AlboomPhotos/src/providers/collections_provider.dart';
import 'package:AlboomPhotos/src/bloc/collections_bloc.dart';
import 'package:AlboomPhotos/src/models/collection_model.dart';

class PhotosListPage extends StatelessWidget {
  final collectionsBloc = new CollectionsBloc();

  @override
  Widget build(BuildContext context) {
    collectionsBloc.getCollections();

    return StreamBuilder<List<Collection>>(
      stream: collectionsBloc.collectionsStreamPhotos,
      builder: (BuildContext context, AsyncSnapshot<List<Collection>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final collections = snapshot.data;

        if (collections.length == 0) {
          return Center(
            child: Text('Ainda sem fotos por aqui'),
          );
        }

        return ListView.builder(
          itemCount: collections.length,
          itemBuilder: (context, i) => Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (direction) => collectionsBloc.deleteCollection(collections[i].id),
                child: ListTile(
                  //leading: Icon(Icons.map, color: Theme.of(context).primaryColor),
                  leading: SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: CachedNetworkImage(
                      imageUrl: CollectionProvider.getReducedImage(collections[i].cover,
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
