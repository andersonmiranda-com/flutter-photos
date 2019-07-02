import 'dart:async';
import 'package:AlboomPhotos/src/models/collection_model.dart';
import 'package:AlboomPhotos/src/providers/collections_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String _galleryId = "";
  List<String> _galleryList = [];
  Collection _collection;
  bool _loadingInProgress = false;
  String _errorText = null;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    height: 70.0,
                    width: 220.0,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Entre o código da galeria"),
                  ),
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
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          height: 46.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: Text("Ver"),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            _checkGalleryId(_galleryId);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    //height: MediaQuery.of(context).size.height * 0.05,
                    height: 20.0,
                  )
                ],
              ),
            ),
            _showLoading()
          ],
        ),
      ),
    );
  }

  _setGalleryId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('galleryList', [_galleryId, _galleryId]);
  }

  _getGalleryId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _galleryList = prefs.getStringList('galleryList') ?? [];
    //print(_galleryList);
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
            _errorText = "Galeria não dispnível";
          });
          return;
        }

        if (_collection.type == "album") {
          setState(() {
            _errorText = "Visualização de álbuns ainda não disponivel";
          });
        }

        if (_collection.type == "photos") {
          Navigator.pushNamed(context, 'gallery', arguments: _collection);
        }
      } else {
        setState(() {
          _errorText = "Galeria Inválida";
        });
      }
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
