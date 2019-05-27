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
  bool _loadingInProgress;

  _getProof(unique_id) {
    API.getProof(unique_id).then((response) {
      var proofData = json.decode(response.body);
      setState(() {
        proofDetails = proofData["proof"];
        proofRows = proofData["rows"];
        _loadingInProgress = false;
      });
      print(proofDetails);
      print(proofRows);
    });
  }

  initState() {
    super.initState();
    _loadingInProgress = true;
    _getProof("k78si6");
  }

  Widget _buildProofItem(BuildContext context, int index) {
    return Container(
        padding: EdgeInsets.all(2.0),
        child: Image.network(
          "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/thumbnails/proofs/723/" +
              proofRows[index]["file"],
          fit: BoxFit.cover,
        ));
  }

  _buildProofGrid() {
    Widget proofGrid;
    if (proofRows.length > 0) {
      proofGrid = GridView.builder(
          padding: EdgeInsets.only(top: 0),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: _buildProofItem,
          itemCount: proofRows.length);
    } else {
      proofGrid = Container();
    }
    return proofGrid;
  }

  Widget _buildBody() {
    if (_loadingInProgress) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
                    proofDetails["name"] != null ? proofDetails["name"] : ""),
                background: proofDetails["name"] != null
                    ? Image.network(
                        "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/723/292-0060.jpg",
//                             + proofDetails["cover"],
                        fit: BoxFit.cover,
                      )
                    : Container(),
                centerTitle: false),
          ),
        ];
      },
      body: Center(child: _buildProofGrid()),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody());
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
