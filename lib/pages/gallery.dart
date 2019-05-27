import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:AlboomProof/API.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  List proofRows = [];
  Map proofDetails = {};

  _getProof(unique_id) {
    API.getProof(unique_id).then((response) {
      var proofData = json.decode(response.body);
      setState(() {
        proofDetails = proofData["proof"];
        proofRows = proofData["rows"];
      });
      print(proofDetails);
      print(proofRows);
    });
  }

  initState() {
    super.initState();
    _getProof("k78si6");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alboom Proof"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              proofDetails["id"] != null ? proofDetails["cover"] : "",
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }
}

// link descrição da prova:
// GET https://andersonmiranda.clicster.com/api/proofs/get_by_unique_id/k78si6/published/S

//LINK imagens:
// POST https://andersonmiranda.clicster.com/api/proofs/select_view
// body:
// {
//  "count": 100,
//  "offset": 0,
//  "unique_id": "k78si6"
// }

//LINK Imagem:
// https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/723/292-0005.jpg
