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

  String _galleryId = "";
  Collection _collection;
  bool _loadingInProgress = false;
  String _errorText;

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Minhas Fotos'),
        backgroundColor: Colors.white,
        elevation: 0.0,

        bottom: PreferredSize(
          child: Container(
            color: Colors.grey,
            height: 0.2,
          ),
          preferredSize: Size.fromHeight(0.2),
        ),

        title: Image.asset(
          "assets/logo-horizontal.png",
          width: 170.0,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                _deleteConfirmAlert(context);
              })
        ],
      ),
      body: Stack(
        children: <Widget>[_callPage(currentIndex), _showLoading()],
      ),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        //onPressed: () => Navigator.pushNamed(context, 'addColection'),
        onPressed: () => _addCollectionAlert(context),
        backgroundColor: Theme.of(context).primaryColor,
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

  void _addCollectionAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
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
                TextField(
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
                child: Text('Cancelar'),
                textColor: Colors.blue,
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text('Ver fotos'),
                  textColor: Colors.red,
                  onPressed: () {
                    _checkGalleryId(_galleryId);
                  }),
            ],
          );
        });
  }

  void _checkGalleryId(uniqueId) {
    if (uniqueId == "") {
      setState(() {
        _errorText = "Por favor entre o código da galeria";
      });
      return;
    }

    setState(() {
      _loadingInProgress = true;
    });

    CollectionProvider.getCollection(uniqueId).then((response) {
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

        collectionsBloc.addCollection(_collection);

        if (_collection.type == "album") {
          setState(() {
            _errorText = "Visualização de álbuns ainda não disponivel";
          });
        }

        if (_collection.type == "photos") {
          Navigator.of(context).pop();
        }
      } else {
        setState(() {
          _errorText = "Galeria Inválida";
        });
      }
    });
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
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                Text('Isto irá deletar todas as galerias', textAlign: TextAlign.center),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                textColor: Colors.blue,
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text('Sim, deletar!'),
                  textColor: Colors.red,
                  onPressed: () {
                    collectionsBloc.deleteAll();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget _showLoading() {
    if (_loadingInProgress) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
        ),
      );
    } else {
      return Container();
    }
  }
}
