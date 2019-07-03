import 'dart:io';

import 'package:AlboomPhotos/src/bloc/collections_bloc.dart';
import 'package:AlboomPhotos/src/pages/albums_list_page.dart';
import 'package:AlboomPhotos/src/pages/photos_list_page.dart';
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
        title: Text('Minhas Fotos'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                _showAlert(context);
              })
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'addColection'),
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

  void _showAlert(BuildContext context) {
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
}
