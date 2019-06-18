import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String _galleryId = "";
  List<String> _galleryList = [];

  _setGalleryId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('galleryList', [_galleryId, _galleryId]);
  }

  _getGalleryId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _galleryList = prefs.getStringList('galleryList') ?? [];
    print(_galleryList);
  }

  void initState() {
    super.initState();
    _getGalleryId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
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
                ),
                onChanged: (value) {
                  _galleryId = value;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: Text("Save"),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        _setGalleryId();
                        print('Saving $_galleryId');
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: Text("Galeria"),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        Navigator.pushNamed(context, 'gallery');
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: RaisedButton(
                      child: Text("Album"),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        Navigator.pushNamed(context, 'album');
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
      ),
    );
  }
}
