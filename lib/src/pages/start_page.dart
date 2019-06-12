import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  String _galleryId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              RaisedButton(
                child: Text("Galeria"),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, 'gallery');
                },
              ),
              RaisedButton(
                child: Text("Album"),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, 'album');
                },
              ),
              SizedBox(
                height: 5.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
