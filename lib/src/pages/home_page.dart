import 'package:AlboomPhotos/src/bloc/collections_bloc.dart';
import 'package:AlboomPhotos/src/models/collection_model.dart';
import 'package:AlboomPhotos/src/pages/albums_list_page.dart';
import 'package:AlboomPhotos/src/pages/photos_list_page.dart';
import 'package:AlboomPhotos/src/providers/collections_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final collectionsBloc = new CollectionsBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Galerias'),
        //backgroundColor: Colors.white,
        elevation: 0.0,
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 0.2,
          ),
          preferredSize: Size.fromHeight(0.2),
        ),
//
//        title: Image.asset(
//          "assets/logo-horizontal.png",
//          width: 170.0,
//        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                _deleteConfirmAlert(context);
              })
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        //onPressed: () => Navigator.pushNamed(context, 'addColection'),
        onPressed: () => showDialog(
              context: context,
              builder: (_) => AddCollectionDialog(),
            ),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return PhotosListPage();
      case 1:
        return AlbumsListPage();

      default:
        return PhotosListPage();
    }
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.photo_camera), title: Text('Photos')),
        BottomNavigationBarItem(icon: Icon(Icons.photo_album), title: Text('Álbuns')),
      ],
    );
  }

  void _deleteConfirmAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Deletar todas fotos',
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Isto irá deletar todas as galerias', textAlign: TextAlign.center),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar', style: TextStyle(fontSize: 16.0)),
                textColor: Colors.grey,
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text('Sim, deletar!', style: TextStyle(fontSize: 16.0)),
                  textColor: Colors.red,
                  onPressed: () {
                    collectionsBloc.deleteAll();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

class AddCollectionDialog extends StatefulWidget {
  @override
  _AddCollectionDialogState createState() => new _AddCollectionDialogState();
}

class _AddCollectionDialogState extends State<AddCollectionDialog> {
  Collection _collection;
  final collectionsBloc = new CollectionsBloc();

  String _galleryId = "";
  bool _loadingInProgress = false;
  String _errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Adicionar galeria',
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _loadingInProgress
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
                )
              : TextField(
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                    hintText: 'Código da galeria',
                    helperText: _errorText,
                    helperStyle: TextStyle(color: Colors.red[900]),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _galleryId = value;
                      _errorText = null;
                    });
                  },
                ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar', style: TextStyle(fontSize: 16.0)),
          textColor: Colors.grey,
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
            child: Text('Abrir', style: TextStyle(fontSize: 16.0)),
            textColor: Colors.red,
            onPressed: () {
              _checkGalleryId(_galleryId);
            }),
      ],
    );
  }

  void _checkGalleryId(_galleryId) {
    if (_galleryId == "") {
      setState(() {
        _errorText = "Por favor entre o código da galeria";
      });
      return;
    }

    setState(() {
      _loadingInProgress = true;
    });

    CollectionProvider.getCollection(_galleryId).then((response) {
      _collection = response;
      setState(() {
        _loadingInProgress = false;
      });

      if (_collection.id != null) {
        if (_collection.priv == true) {
          setState(() {
            _errorText = "Galeria não disponível";
          });
          return;
        }

        collectionsBloc.upsertCollection(_collection);

        if (_collection.type == "album") {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, 'album', arguments: _collection);
        }

        if (_collection.type == "photos") {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, 'gallery', arguments: _collection);
        }
      } else {
        setState(() {
          _errorText = "Galeria Inválida";
        });
      }
    });
  }
}
